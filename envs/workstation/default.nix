{ pkgs }:

with pkgs; let
  minimalPaths =
    if (stdenv.system == "x86_64-linux") then
      [ firefox
        nixops
      ]
    else
      [ ];

  extraPaths =
    if (stdenv.system == "x86_64-linux") then
      [ ]
    else
      [ ];
in
{
  minimal = buildEnv {
    name = "minimal-workstation-environment";
    paths = minimalPaths;
  };

  extra = buildEnv {
    name = "extra-workstation-environment";
    paths = minimalPaths ++ extraPaths;
  };
}
