{ pkgs ? import <nixpkgs> {} }:
with pkgs;

vim_configurable.customize {
  name = "vi";
  vimrcConfig.customRC = ''
  let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

  nnoremap <F5> :call LanguageClient_contextMenu()<CR>
  map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
  map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
  map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
  map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
  map <Leader>lb :call LanguageClient#textDocument_references()<CR>
  map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
  map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

  hi link ALEError Error
  hi Warning term=underline cterm=underline ctermfg=Yellow gui=undercurl guisp=Gold
  hi link ALEWarning Warning
  hi link ALEInfo SpellCap

  let g:LanguageClient_rootMarkers = ['*.cabal', 'stack.yaml']
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
