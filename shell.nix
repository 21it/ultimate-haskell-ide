let nixpkgs = import ./nixpkgs22.nix;
in
{
  pkgs ? import nixpkgs {},
  bundle ? null
}:
with pkgs;

let pkg = import ./. {inherit bundle;};
in

stdenv.mkDerivation {
  name = "vimrc-awesome-shell";
  buildInputs = [ pkg ];
  TERM="xterm-256color";
}
