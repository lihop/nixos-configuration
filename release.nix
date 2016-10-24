{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  makeTest = import <nixpkgs/nixos/tests/make-test.nix>;
  pkgs = import nixpkgs { };
  lib = pkgs.lib;

  roleTest = path: args: lib.hydraJob (makeTest {
    testScript = "";
    machine =
      { config, pkgs, ... }:
      { imports = [ (import (./roles + path) { inherit config; inherit pkgs; }) ];
      };
  } args);
in
{
  common = roleTest /common { };
  hydra = roleTest /hydra { };
  hydraProxy = roleTest /hydra/proxy.nix { };
  mail = roleTest /mail { };
  monitored = roleTest /monitored { };
  mysqlMaster = roleTest /mysql/master.nix { };
  mysqlSlave = roleTest /mysql/slave.nix { };
  server = roleTest /server { };
  steamMachine = roleTest /steam-machine { };
  workstation = roleTest /workstation { };
  workstationExtra = roleTest /workstation-extra { };

  environments = pkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
      (import ./envs { inherit pkgs; }).environments
  );
}
