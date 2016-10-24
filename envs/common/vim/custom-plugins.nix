{pkgs, ...}:

{
  bbye = pkgs.vimUtils.buildVimPlugin {
    name = "vim-bbye";
    src = pkgs.fetchFromGitHub {
      owner = "moll";
      repo = "vim-bbye";
      rev = "a018cbc1ba63b1a8b86b7c468645e7642637ec4a";
      sha256 = "156hw6iddh02gcwinz873m32xbvi0rml2cik7542c6gk88bak9z9";
    };
  };

  gitignore = pkgs.vimUtils.buildVimPlugin {
    name = "vim-gitignore";
    src = pkgs.fetchFromGitHub {
      owner = "gisphm";
      repo = "vim-gitignore";
      rev = "b4c3b471d61b0973d04bc550fdd336dba985cb91";
      sha256 = "19a5hjnvlakva672bbsld7krm890qc623hx9kq2kmz6sys6afvf3";
    };
  };

  mundo = pkgs.vimUtils.buildVimPlugin {
    name = "vim-mundo";
    src = pkgs.fetchFromGitHub {
      owner = "simnalamburt";
      repo = "vim-mundo";
      rev = "77dd14c9923d2824c6b328b2b7441dcdfb9a71d3";
      sha256 = "1f5jni0a5nyyiw67yv1d6ifzmfyzmcdn697cfjdj7d9r4hzwwmz4";
    };
  };

  indentObject = pkgs.vimUtils.buildVimPlugin {
    name = "vim-indent-object";
    src = pkgs.fetchFromGitHub {
      owner = "michaeljsmith";
      repo = "vim-indent-object";
      rev = "1d3e4aac0117d57c3e1aaaa7e5a99f1d7553e01b";
      sha256 = "1xxl5pwbz56qjfxw6l686m1qc4a3q0r7afa9r5gjhgd1jy67z7d7";
    };
  };
}
