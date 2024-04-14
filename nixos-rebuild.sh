#!/usr/bin/env bash

set -e

pushd ~/nixos

if [[ -z `git status --porcelain` ]]; then
    echo "No changes in configuration, exiting."
    popd
    exit 1
fi

nixfmt .
git add .

echo "Rebuilding NixOS configuration..."

sudo nixos-rebuild switch --flake .#ga401

current_generation=$(nixos-rebuild list-generations --flake . | grep current)

generation_tag=$(echo $current_generation | awk '{ print $1 }')
generation_description=$(echo $current_generation | awk '{ print $3, $4 }')

git commit -m "generation: $generation_tag - $generation_description"
git push

popd
