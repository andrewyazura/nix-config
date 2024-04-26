#!/usr/bin/env bash

set -e

pushd ~/nixos

sudo nix flake update
sudo nixos-rebuild switch --flake .#ga401

popd
