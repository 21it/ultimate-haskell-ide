{ pkgs ? import <nixpkgs> {} }:
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
    vimrc-awesome = stdenv.mkDerivation {
      name = "vimrc-awesome";
      src = nix-gitignore.gitignoreSourcePure ignore-patterns ./.;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/
        cp -R ./ $out/
      '';
    };

in

vim_configurable.customize {
  name = "vi";
  vimrcConfig.customRC = ''
  set runtimepath+=${vimrc-awesome}

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
}
