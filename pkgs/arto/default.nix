{
  lib,
  system,
  artoFlake ? null,
}:

let
  isDarwin = lib.hasSuffix "-darwin" system;
  hasArtoPackage = artoFlake != null && artoFlake.packages ? ${system};
in

if isDarwin && hasArtoPackage then
  artoFlake.packages.${system}.arto
else
  null
