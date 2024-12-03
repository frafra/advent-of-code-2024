#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p duckdb
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-24.10.tar.gz

cd "$(dirname $0)"
exec duckdb < solution.sql
