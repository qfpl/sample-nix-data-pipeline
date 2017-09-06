{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
in
  pkgs.stdenv.mkDerivation {
    name = "in1";
    src = ./data.txt;
    installPhase = ''
      mkdir $out
      cp $src $out/data.txt
    '';
    phases = ["installPhase"];
  }
