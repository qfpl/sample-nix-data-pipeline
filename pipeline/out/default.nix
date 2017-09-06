{}:
let
  _nixpkgs = import <nixpkgs> {};
  nixpkgs = import (_nixpkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "56da88a298a6f549701a10bb12072804a1ebfbd5";
    sha256 = "0cacw30vy4xswpkj3vbw92xfv5q06mw22msq0i54gphmw2r5iizh";
  }) {};

  inherit (nixpkgs) pkgs;
  data1 = import ../middle1 { inherit nixpkgs; };
  data2 = import ../middle2 { inherit nixpkgs; };
  program = import ../../programs/step2 { inherit nixpkgs; };
in
  pkgs.runCommand "out" {} ''
    mkdir $out
    ${program}/bin/step2 ${data1}/data.txt ${data2}/data.txt $out/data.txt
  ''
