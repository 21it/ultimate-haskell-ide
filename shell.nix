let nixpkgs = import ./nixpkgs22.nix;
in
{
  pkgs ? import nixpkgs {}
}:
with pkgs;

let pkg = import ./. {};
in

stdenv.mkDerivation {
  name = "vimrc-awesome-shell";
  buildInputs = [ pkg ];
  TERM="xterm-256color";
}
