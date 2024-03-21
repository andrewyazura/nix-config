#!/usr/bin/env bash

set -e

pushd ~/nixos

if [[ -z `git status --porcelain` ]]; then
    echo "No changes in configuration, exiting."
    exit 1
fi

nixfmt .

echo "Rebuilding NixOS configuration..."

sudo nixos-rebuild switch --flake .#nixos

generation_tag = $(nixos-rebuild list-generations --flake . | grep current | awk '{ print $1, $3, $4 }')

git commit -am "rebuild: $generation_tag"
git push

popd
