#!/bin/sh

set -e

docker run -it --rm \
  -e NIXPKGS_ALLOW_BROKEN=1 \
  -v "$(pwd):/app" \
  -v "nix:/nix" \
  -w "/app" nixos/nix:2.3 sh -c "
  nix-channel --add https://nixos.org/channels/nixos-19.09 nixpkgs &&
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable &&
  nix-channel --update &&
  nix-env -iA cachix -f https://cachix.org/api/v1/install &&
  cachix use all-hies &&
  nix-shell --pure
  "
