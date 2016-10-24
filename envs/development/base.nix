{ pkgs }:

with pkgs; buildEnv {
  name = "base-development-environment";
  paths =
    if (stdenv.system == "x86_64-linux") then
      [ idea.idea-ultimate
      ]
    else
      [ ];
}
