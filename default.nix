let nixpkgs19src = import ./nixpkgs19.nix;
    nixpkgs20src = import ./nixpkgs20.nix;
    nixpkgsMasterSrc = import ./nixpkgs-master.nix;
    nixpkgs19 = import nixpkgs19src {};
    nixpkgs20 = import nixpkgs20src {};
    nixpkgsMaster = import nixpkgsMasterSrc {};
in
{
  pkgs ? nixpkgs19,
  deps ? null,
  ormolu ? nixpkgs20.haskellPackages.ormolu,
  vimBackground ? "light",
  vimColorScheme ? "PaperColor",
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
        nixpkgsMaster.haskellPackages.stack
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
    vimrc-awesome' = nixpkgsMaster.vim_configurable.customize {
      name = "vi";
      vimrcConfig.customRC = ''
      set runtimepath+=${vimrc-awesome}
      let $PATH.=':${ag}/bin'

      source ${vimrc-awesome}/vimrcs/basic.vim
      source ${vimrc-awesome}/vimrcs/filetypes.vim
      source ${vimrc-awesome}/vimrcs/plugins_config.vim
      source ${vimrc-awesome}/vimrcs/extended.vim

      if !exists("g:vimBackground")
        let g:vimBackground = '${vimBackground}'
      endif

      if !exists("g:vimColorScheme")
        let g:vimColorScheme = '${vimColorScheme}'
      endif

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
    deps' =
      if deps != null
      then deps
      else [
        /* Haskell tools */
        ghc
        hie
        ormoluDerivation
        haskellPackages.hlint
        haskellPackages.hoogle
        haskellPackages.apply-refact
        /* DHall */
        nixpkgsMaster.dhall
        nixpkgsMaster.dhall-json
      ];
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
      /* Other */
      ag
      nix
      git
      curl
      less
    ] ++ deps';
  }

