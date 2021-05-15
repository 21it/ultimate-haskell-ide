let nixpkgs19src = import ./nixpkgs19.nix;
    nixpkgs20src = import ./nixpkgs20.nix;
    nixpkgsMasterSrc = import ./nixpkgs-master.nix;
    nixpkgs19 = import nixpkgs19src {};
    nixpkgs20 = import nixpkgs20src {};
    nixpkgsMaster = import nixpkgsMasterSrc {};
    mavenix = import (fetchTarball "https://github.com/nix-community/mavenix/tarball/7416dbd2861520d44a4d6ecee9d94f89737412dc") {};
    all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/archive/4b984030c8080d944372354a7b558c49858057e7.tar.gz") {};
in
{
  pkgs ? nixpkgs19,
  bundle ? "haskell",
  vimBackground ? "light",
  vimColorScheme ? "PaperColor",
}:
with pkgs;
with builtins;
with lib.lists;

let bundles =
      if isList bundle
      then bundle
      else singleton bundle;
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
    hie = all-hies.unstable.selection { selector = p: { inherit (p) ghc865; }; };
    ghc = haskellPackages.ghcWithPackages (hpkgs: with hpkgs;
      [
        nixpkgsMaster.haskellPackages.stack
        cabal-install
        zlib
      ]
    );
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
    };
    bundle-registry = {
      minimal = [

      ];
      haskell = [
        ghc
        hie
        cabal2nix
        haskellPackages.hlint
        haskellPackages.hoogle
        haskellPackages.apply-refact
        haskellPackages.hspec-discover
        nixpkgs20.haskellPackages.ormolu
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
      git
      curl
      less
    ] ++ (concatMap (x: getAttr x bundle-registry) bundles);
  }

