let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;

in stdenv.mkDerivation rec {
  name = "devcgcfg";

  buildInputs = with pkgs; [
    gcc
    gnumake
  ];
}
