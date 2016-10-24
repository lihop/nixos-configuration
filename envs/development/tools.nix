{ pkgs }:

with pkgs; buildEnv {
  name = "development-tools";
  paths = [
    bind
    gcc
    git
    netcat
    nmap
  ];
}
