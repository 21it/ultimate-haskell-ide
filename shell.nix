let nixpkgs19 = import ./nixpkgs19.nix;
in
{
  pkgs ? import nixpkgs19 {}
}:
with pkgs;

let pkg = import ./. {};
in

stdenv.mkDerivation {
  name = "vimrc-awesome-shell";
  buildInputs = [ pkg ];
  TERM="xterm-256color";
}
