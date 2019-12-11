#!/bin/sh

set -e

docker run -it --rm \
  -e NIXPKGS_ALLOW_BROKEN=1 \
  -v "$(pwd):/app" \
  -v "nix:/nix" \
  -w "/app" nixos/nix:2.3 sh -c "nix-shell --pure"
