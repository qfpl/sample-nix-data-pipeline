{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  data = import ../../data/in1 { inherit nixpkgs; };
  program = import ../../programs/step1a { inherit nixpkgs; };
in
  pkgs.runCommand "middle1" {} ''
      mkdir $out
      ${program}/bin/step1a ${data}/data.txt $out/data.txt
  ''
