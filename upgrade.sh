#!/usr/bin/env bash

set -e

pushd ~/nixos > /dev/null 2>&1

sudo nix flake update
./rebuild.sh

popd > /dev/null 2>&1
