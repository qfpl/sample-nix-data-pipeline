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
  data1 = import ../../data/in1 { inherit nixpkgs; };
  data2 = import ../../data/in2 { inherit nixpkgs; };
  step1a = import ../../programs/step1a { inherit nixpkgs; };
  step1b = import ../../programs/step1b { inherit nixpkgs; };
  step2 = import ../../programs/step2 { inherit nixpkgs; };

  middle1 = pkgs.runCommand "middle1" {} ''
      mkdir $out
      ${step1a}/bin/step1a ${data1}/data.txt $out/data.txt
  '';

  middle2 = pkgs.runCommand "middle2" {} ''
      mkdir $out
      ${step1b}/bin/step1b ${data2}/data.txt $out/data.txt
  '';

  out = pkgs.runCommand "out" {} ''
      mkdir $out
      ${step2}/bin/step2 ${middle1}/data.txt ${middle2}/data.txt $out/data.txt
  '';

in
  out
