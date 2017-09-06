{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  pythonPackages = pkgs.python36Packages;
in
  pythonPackages.buildPythonPackage rec {
    name = "step2";
    src = ./.;
  }
