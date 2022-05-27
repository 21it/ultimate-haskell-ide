let nixpkgsMasterSrc = import ./nixpkgs-master.nix;
    nixpkgsMaster = import nixpkgsMasterSrc {};
    pkgs20 = import (import ./nixpkgs20.nix) {};
    pkgs21 = import (import ./nixpkgs21.nix) {};
    pkgs22 = import (import ./nixpkgs22.nix) {};
    mavenix = import (fetchTarball "https://github.com/nix-community/mavenix/tarball/7416dbd2861520d44a4d6ecee9d94f89737412dc") {};
    nixToolsSrc = import (fetchTarball "https://github.com/input-output-hk/nix-tools/tarball/617b77da9ad734e7b5ee1d7f1dbb09abe924960d") {};
    nixTools = nixToolsSrc.nix-tools.components.exes;
in
{
  pkgs ? nixpkgsMaster,
  bundle ? "haskell",
  withGit ? true,
  formatter ? "ormolu",
  vimBackground ? "dark",
  vimColorScheme ? "PaperColor",
  # optional tool replacement
  cabal-install ? pkgs20.cabal-install
}:
with pkgs;
with builtins;
with lib.lists;

let bundles =
      if isList bundle
      then bundle
      else singleton bundle;
    gitDerivations =
      if withGit
      then [git]
      else [];
    ignore-patterns = ''
      .git
      .gitignore
      *.nix
      *.sh
      *.md
      *.py
      LICENSE
      result
    '';
    vimrc-awesome = stdenv.mkDerivation {
      name = "vimrc-awesome";
      src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/
        cp -R ./ $out/
      '';
    };
    formatter-registry = {
      ormolu = ''
      let g:brittany_on_save = 0
      let g:ormolu_disable = 0
      '';
      brittany = ''
      let g:brittany_on_save = 1
      let g:ormolu_disable = 1
      '';
      none = ''
      let g:brittany_on_save = 0
      let g:ormolu_disable = 1
      '';
    };
    bundle-registry = {
      minimal = [

      ];
      haskell = [
        pkgs22.haskell.compiler.ghc922
        pkgs22.haskellPackages.stack
        cabal-install
        zlib
        haskell-language-server
        cabal2nix
        niv
        ghcid
        haskellPackages.hlint
        haskellPackages.hoogle
        haskellPackages.apply-refact
        haskellPackages.hspec-discover
        haskellPackages.implicit-hie
        haskellPackages.ormolu
        haskellPackages.brittany
      ];
      dhall = [
        nixpkgsMaster.dhall
        nixpkgsMaster.dhall-json
      ];
      maven = [
        jdk11
        maven
        mavenix.cli
      ];
      elixir = [
        elixir
        inotify-tools
      ];
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

      if !exists("g:languagetool_cmd")
        let g:languagetool_cmd = '${languagetool}/bin/languagetool-commandline'
      endif

      try
      source ${vimrc-awesome}/my_configs.vim
      catch
      endtry

      '' + (getAttr formatter formatter-registry);
    };
in
  stdenv.mkDerivation{
    name = "vi";
    src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
    dontBuild = true;
    dontInstall = true;
    propagatedBuildInputs = [
      /* vim + coc */
      vimrc-awesome'
      nodejs
      /* other */
      ag
      nix
      curl
      less
    ]
    ++ gitDerivations
    ++ (concatMap (x: getAttr x bundle-registry) bundles);
  }

