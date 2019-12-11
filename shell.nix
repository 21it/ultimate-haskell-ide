{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let pkg = import ./. {};
in

stdenv.mkDerivation {
  name = "itkachuk-vim";
  buildInputs = [ pkg ];
}
