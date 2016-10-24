{ pkgs }:

with pkgs; buildEnv {
  name = "node-development-environment";
  paths = [
    nodejs
    npm2nix
  ];
}
