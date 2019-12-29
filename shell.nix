{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let pkg = import ./. {};
in

stdenv.mkDerivation {
  name = "vimrc-awesome-shell";
  buildInputs = [ pkg git ag nodejs ];
  TERM="xterm-256color";
}
