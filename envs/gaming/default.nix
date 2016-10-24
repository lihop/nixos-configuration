{ pkgs }:

with pkgs; buildEnv {
  name = "gaming-environment";
  paths =
    if (stdenv.system == "x86_64-linux") then
      [ (dwarf-fortress.override {
          theme = dwarf-fortress-packages.phoebus-theme;
        })
        minetest
        openttd
        steam
        superTuxKart
        zeroad
      ]
    else
      [ ];
}
