{ pkgs }:

with pkgs; buildEnv {
  name = "java-development-environment";
  paths = [
    maven
    openjdk8
  ];
}
