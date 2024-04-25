#!/usr/bin/env bash

set -e

pushd ~/nixos

sudo nix-channel --update
sudo nixos-rebuild switch --flake .#ga401

popd
