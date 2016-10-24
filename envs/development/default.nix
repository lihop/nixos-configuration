{ pkgs }:

with pkgs; {
  base = import ./base.nix { inherit pkgs; }; 
  haskell = import ./haskell.nix { inherit pkgs; };
  java = import ./java.nix { inherit pkgs; };
  node = import ./node.nix { inherit pkgs; };
  tools = import ./tools.nix { inherit pkgs; };
}
