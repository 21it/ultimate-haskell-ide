let nixpkgs = import ./nixpkgs22.nix;
in
{
  pkgs ? import nixpkgs {},
  bundle ? null,
  vimBackground ? "light",
  vimColorScheme ? "PaperColor"
}:
with pkgs;

let pkg = import ./. {
      inherit bundle vimBackground vimColorScheme;
    };
in

stdenv.mkDerivation {
  name = "vimrc-awesome-shell";
  buildInputs = [ pkg ];
  TERM="xterm-256color";
}
