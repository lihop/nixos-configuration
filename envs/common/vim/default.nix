{ pkgs }:
let
  supportBundles = {
    names = [
      "tslime"
      "vimproc"
      "Supertab"
      "neomake"
      "bbye"
      "vim-indent-guides"
      "gitignore"
    ];
  };

  gitPlugins = {
    names = [
      "fugitive"
      "extradite"
    ];
  };

  barsPanelsFiles = {
    names = [
      "The_NERD_tree"
      "airline"
      "ctrlp"
      "Tagbar"
      "tmux-navigator"
    ];
  };

  textManipulation = {
    names = [
      "align"
      "mundo"
      "commentary"
      "tabular"
      "indentObject"
      "vim-easymotion"
    ];
  };

  haskellPlugins = {
    names = [
      "haskell-vim"
      "ghc-mod-vim"
      "neco-ghc"
      "Hoogle"
      "hlint-refactor"
    ];
  };

  colorScheme = {
    names = [
      "wombat256"
    ];
  };
in
with pkgs; buildEnv {
  name = "customized-vim";
  paths = [
    haskellPackages.ghc-mod
    haskellPackages.hoogle
    ( vim_configurable.customize {
        name = "vim";
        vimrcConfig = {
          customRC = builtins.readFile ./vimrc;
          vam.knownPlugins = vimPlugins // import ./custom-plugins.nix pkgs;
          vam.pluginDictionaries = [
            supportBundles
            gitPlugins
            barsPanelsFiles
            textManipulation
            haskellPlugins
          ];
        };
      }
    )
  ];
}
