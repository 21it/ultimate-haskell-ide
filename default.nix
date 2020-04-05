let nixpkgs19 = import ./nixpkgs19.nix;
    nixpkgs20 = import ./nixpkgs20.nix;
in
{
  pkgs ? import nixpkgs19 {},
  ormolu ? (import nixpkgs20 {}).haskellPackages.ormolu
}:
with pkgs;

let ignore-patterns = ''
      .git
      .gitignore
      *.nix
      *.sh
      *.md
      *.py
      LICENSE
      result
    '';
    all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/archive/4b984030c8080d944372354a7b558c49858057e7.tar.gz") {};
    hie = all-hies.unstable.selection { selector = p: { inherit (p) ghc865; }; };
    ghc = haskellPackages.ghcWithPackages (hpkgs: with hpkgs;
      [
        stack
        cabal-install
        zlib
      ]
    );
    ormoluDerivation = if ormolu == null then haskellPackages.ormolu else ormolu;
    vimrc-awesome = stdenv.mkDerivation {
      name = "vimrc-awesome";
      src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/
        cp -R ./ $out/
      '';
    };
    vimrc-awesome' = vim_configurable.customize {
      name = "vi";
      vimrcConfig.customRC = ''
      set runtimepath+=${vimrc-awesome}
      let $PATH.=':${ag}/bin'

      source ${vimrc-awesome}/vimrcs/basic.vim
      source ${vimrc-awesome}/vimrcs/filetypes.vim
      source ${vimrc-awesome}/vimrcs/plugins_config.vim
      source ${vimrc-awesome}/vimrcs/extended.vim

      try
      source ${vimrc-awesome}/my_configs.vim
      catch
      endtry
      '';
      vimrcConfig.packages.vimrc-awesome = with vimPlugins; {
        # loaded on launch
        start = [];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [];
        # To automatically load a plugin when opening a filetype, add vimrc lines like:
        # autocmd FileType php :packadd phpCompletion
      };
    };
in
  stdenv.mkDerivation{
    name = "vi";
    src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
    dontBuild = true;
    dontInstall = true;
    propagatedBuildInputs = [
      /* Vim + plugins */
      vimrc-awesome'
      nodejs
      /* Haskell tools */
      ghc
      hie
      ormoluDerivation
      haskellPackages.hlint
      haskellPackages.hoogle
      haskellPackages.apply-refact
      /* Other */
      ag
      nix
      git
      curl
      less
    ];
  }

