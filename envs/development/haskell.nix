{ pkgs }:

with pkgs; buildEnv {
  name = "haskell-development-environment";
  paths = [
    stack
  ];
}
