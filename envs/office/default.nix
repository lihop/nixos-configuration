{ pkgs }:

with pkgs; let
  minimalPaths =
    if (stdenv.system == "x86_64-linux") then
      [ mupdf
        neomutt
        (texlive.combine {
          inherit (texlive) scheme-small;
        })
      ]
    else
      [ neomutt
        (texlive.combine {
          inherit (texlive) scheme-small;
        })
      ];

  extraPaths =
    if (stdenv.system == "x86_64-linux") then
      [ libreoffice
      ]
    else
      [ ];
in
{
  minimal = buildEnv {
    name = "minimal-office-environment";
    paths = minimalPaths;
  };

  extra = buildEnv {
    name = "extra-office-environment";
    paths = minimalPaths ++ extraPaths;
  };
}
