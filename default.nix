let pkgs22 = import (import ./nixpkgs22.nix) {};
in
{
  pkgs ? pkgs22,
  bundle ? "haskell",
  withGit ? true,
  formatter ? "ormolu",
  vimBackground ? "light",
  vimColorScheme ? "PaperColor"
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
        haskell.compiler.ghc902
        haskellPackages.stack
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
        dhall
        dhall-json
      ];
    };
    lesspipe' = writeShellScriptBin "lesspipe" "${lesspipe}/bin/lesspipe.sh";
    vimrc-awesome' = neovim.override {
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          set runtimepath+=${vimrc-awesome}
          let $PATH.=':${silver-searcher}/bin:${nodejs}/bin:${less}/bin:${lesspipe'}/bin:${python38Packages.grip}/bin:${xdg_utils}/bin'

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
        packages.vim21 = with pkgs.vimPlugins; {
          start = [
            # Interface
            ack-vim
            ctrlp-vim
            vim-fugitive
            vim-gitgutter
            lightline-vim
            papercolor-theme
            vim-better-whitespace
            # Programming
            haskell-vim
            hlint-refactor-vim
            vim-ormolu
            vim-nix
            dhall-vim
            psc-ide-vim
            purescript-vim
            # Productivity
            coc-nvim
            sideways-vim
            vim-LanguageTool
          ];
          opt = [

          ];
        };
      };
    };
in
  vimrc-awesome'
  # stdenv.mkDerivation {
  #   name = "vi";
  #   src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
  #   dontBuild = true;
  #   dontInstall = true;
  #   propagatedBuildInputs = [
  #     /* vim + plugins */
  #     vimrc-awesome'
  #     /* other */
  #     nix
  #     curl
  #   ]
  #   ++ gitDerivations
  #   ++ (concatMap (x: getAttr x bundle-registry) bundles);
  # }

