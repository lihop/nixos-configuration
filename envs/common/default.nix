{ pkgs }:

let
  vim = import ./vim { inherit pkgs; };
in
with pkgs; buildEnv {
  name = "common-environment";
  paths = [
    git
    htop
    tmux
    vim
  ];
}
