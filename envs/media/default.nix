{ pkgs }:

with pkgs; let
  minimalPaths =
    if (stdenv.system == "x86_64-linux") then
      [ transmission_gtk
        vlc
      ]
    else
      [ ];

  extraPaths =
    if (stdenv.system == "x86_64-linux") then
      [ inkscape
        audacity
        gimp
        openshot-qt
      ]
    else
      [ ];
in
{
  minimal = buildEnv {
    name = "minimal-media-environment";
    paths = minimalPaths; 
  };

  extra = buildEnv {
    name = "extra-media-environment";
    paths = minimalPaths ++ extraPaths;
  };
}
