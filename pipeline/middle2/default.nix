{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  data = import ../../data/in2 { inherit nixpkgs; };
  program = import ../../programs/step1b { inherit nixpkgs; };
in
  pkgs.runCommand "middle2" {} ''
      mkdir $out
      ${program}/bin/step1b ${data}/data.txt $out/data.txt
  ''
