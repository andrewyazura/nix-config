#!/usr/bin/env bash

set -e

pushd ~/nixos > /dev/null 2>&1

sudo nix flake update
sudo nixos-rebuild switch --flake .#ga401

popd > /dev/null 2>&1
