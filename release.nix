{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  makeTest = import <nixpkgs/nixos/tests/make-test.nix>;
  pkgs = import nixpkgs { };
  lib = pkgs.lib;

  roleTest = path: args: lib.hydraJob (makeTest {
    testScript = "";
    machine =
      { config, pkgs, ... }:
      { nixpkgs.config.allowUnfree = true;
        imports = [ (import (./roles + path) { inherit config; inherit pkgs; }) ];
      };
  } args);
in
{
  roles = {
    common = roleTest /common { };
    gaming = roleTest /gaming { };
    hydra = roleTest /hydra { };
    hydraProxy = roleTest /hydra/proxy.nix { };
    hydraSlave = roleTest /hydra/slave.nix { };
    mail = roleTest /mail { };
    monitored = roleTest /monitored { };
    mysqlMaster = roleTest /mysql/master.nix { };
    mysqlSlave = roleTest /mysql/slave.nix { };
    server = roleTest /server { };
    workstation = roleTest /workstation { };
    workstationExtra = roleTest /workstation-extra { };
  };

  environments = pkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
      (import ./envs { inherit pkgs; }).environments
  );
}
