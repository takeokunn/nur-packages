#!/usr/bin/env python3
import json
import os
import selectors
import signal
import subprocess
import sys
import tempfile
import time


def wait_for_process_group(process: subprocess.Popen[str], timeout: float) -> bool:
    deadline = time.monotonic() + timeout
    while True:
        process.poll()
        try:
            os.killpg(process.pid, 0)
        except ProcessLookupError:
            process.poll()
            return True
        except PermissionError:
            # EPERM means a process remains in the group but the sandbox cannot query it.
            pass
        if time.monotonic() >= deadline:
            return False
        time.sleep(0.05)


def stop_process_group(process: subprocess.Popen[str]) -> tuple[bool, bool]:
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        return True, True
    except PermissionError:
        return False, False

    if wait_for_process_group(process, timeout=5):
        return True, True

    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        return False, True
    except PermissionError:
        return False, False
    return False, wait_for_process_group(process, timeout=5)


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: mcp_server_check.py SERENA_EXECUTABLE TEMP_DIRECTORY")

    executable, temp_directory = sys.argv[1:]
    request = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "nur-packages-serena-check", "version": "1.0.0"},
        },
    }

    with tempfile.TemporaryDirectory(prefix="serena-home-", dir=temp_directory) as serena_home:
        env = os.environ.copy()
        env["SERENA_HOME"] = serena_home
        process = subprocess.Popen(
            [executable, "start-mcp-server", "--enable-web-dashboard", "false"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            env=env,
            start_new_session=True,
        )
        process_group_handled = False
        try:
            process.stdin.write(json.dumps(request) + "\n")
            process.stdin.close()
            stdout_lines = []
            stderr_lines = []
            response = None
            timed_out = False
            deadline = time.monotonic() + 60

            with selectors.DefaultSelector() as selector:
                selector.register(process.stdout, selectors.EVENT_READ, "stdout")
                selector.register(process.stderr, selectors.EVENT_READ, "stderr")
                while selector.get_map():
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        timed_out = True
                        break
                    events = selector.select(remaining)
                    if not events:
                        timed_out = True
                        break
                    for key, _ in events:
                        line = key.fileobj.readline()
                        if line == "":
                            selector.unregister(key.fileobj)
                            continue
                        if key.data == "stderr":
                            stderr_lines.append(line)
                            continue
                        if response is not None:
                            stdout_lines.append(line)
                            continue
                        if line.strip():
                            try:
                                candidate = json.loads(line)
                            except json.JSONDecodeError as error:
                                raise SystemExit(
                                    f"Serena wrote non-JSON output to stdout: {line}"
                                ) from error
                            if isinstance(candidate, dict) and candidate.get("id") == request["id"]:
                                response = candidate
                                stdout_lines.append(line)
                                continue
                        stdout_lines.append(line)

            stdout = "".join(stdout_lines)
            stderr = "".join(stderr_lines)
            if response is None:
                returncode = process.poll()
                if not timed_out and returncode is not None:
                    process_group_handled = True
                    raise SystemExit(
                        f"Serena exited with status {returncode}\n"
                        f"stdout:\n{stdout}\n"
                        f"stderr:\n{stderr}"
                    )
                ended_after_sigterm, group_gone = stop_process_group(process)
                process_group_handled = True
                reason = (
                    "Serena did not respond to initialize before timeout"
                    if timed_out
                    else "Serena did not respond to initialize"
                )
                if not ended_after_sigterm:
                    reason += "; process group remained after SIGTERM"
                if not group_gone:
                    reason += " and after SIGKILL"
                raise SystemExit(f"{reason}\nstdout:\n{stdout}\nstderr:\n{stderr}")

            result = response.get("result")
            if response.get("jsonrpc") != "2.0" or not isinstance(result, dict):
                raise SystemExit(f"Serena returned an invalid initialize response: {response}")
            if not isinstance(result.get("protocolVersion"), str) or not isinstance(
                result.get("serverInfo"), dict
            ):
                raise SystemExit(f"Serena returned an incomplete initialize result: {result}")

            if timed_out or not wait_for_process_group(
                process, timeout=max(0, deadline - time.monotonic())
            ):
                ended_after_sigterm, group_gone = stop_process_group(process)
                process_group_handled = True
                reason = "Serena process group did not exit on its own after initialize before timeout"
                if not ended_after_sigterm:
                    reason += "; process group remained after SIGTERM"
                if not group_gone:
                    reason += " and after SIGKILL"
                raise SystemExit(reason)

            process_group_handled = True
            returncode = process.poll()
            if returncode != 0:
                raise SystemExit(
                    f"Serena exited with status {returncode}\nstdout:\n{stdout}\nstderr:\n{stderr}"
                )

            print("Serena MCP server process group exited after initialize.")
        finally:
            if not process_group_handled:
                _, group_gone = stop_process_group(process)
                if not group_gone:
                    print("Serena process group remained after SIGKILL", file=sys.stderr)
            process.poll()
            process.stdout.close()
            process.stderr.close()


if __name__ == "__main__":
    main()
