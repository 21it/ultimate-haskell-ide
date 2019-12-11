{ pkgs ? import <nixpkgs> {} }:
with pkgs;

vim_configurable.customize {
  name = "vi";
  #
  # TODO : how to use current package directories here?
  #
  vimrcConfig.customRC = ''
  set runtimepath+=~/.vim_runtime

  source ~/.vim_runtime/vimrcs/basic.vim
  source ~/.vim_runtime/vimrcs/filetypes.vim
  source ~/.vim_runtime/vimrcs/plugins_config.vim
  source ~/.vim_runtime/vimrcs/extended.vim

  try
  source ~/.vim_runtime/my_configs.vim
  catch
  endtry
  '';
  vimrcConfig.packages.itkachuk = with vimPlugins; {
    # loaded on launch
    start = [ haskell-vim vim-hindent LanguageClient-neovim ];
    # manually loadable by calling `:packadd $plugin-name`
    opt = [];
    # To automatically load a plugin when opening a filetype, add vimrc lines like:
    # autocmd FileType php :packadd phpCompletion
  };
}
