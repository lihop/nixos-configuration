{ pkgs }:

let
  envs = import ./envs { inherit pkgs; };
in
{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; envs;
}
