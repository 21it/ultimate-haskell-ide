" Better infix functions in Haskell
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'override' : {
  \       'color10' : ['#d70087', '162'],
  \       'color13' : ['#d75f00', '166'],
  \       }
  \     }
  \   }
  \ }

syntax on
filetype plugin indent on
set t_Co=256
exe 'set background=' . get(g:, "vimBackground", "light")
exe 'colorscheme ' . get(g:, "vimColorScheme", "PaperColor")
exe 'let g:languagetool_jar=' . get(g:, "languagetool_jar", "$LANGUAGE_TOOL_JAR")
let g:languagetool_disable_rules="DASH_RULE,WHITESPACE_RULE,EN_QUOTES"
autocmd VimEnter * :vs | :te
autocmd VimEnter * :vert resize -14
set colorcolumn=67
let g:brittany_on_save = 0
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
nnoremap <SPACE> <Nop>
let mapleader = "\\"
set splitright
set expandtab
set shiftwidth=2
let vim_markdown_preview_toggle=1
let vim_markdown_preview_hotkey='<C-p>'
let vim_markdown_preview_browser='Firefox'
let vim_markdown_preview_temp_file=1
let vim_markdown_preview_github=1
let vim_markdown_preview_use_xdg_open=1
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help']
let g:gitgutter_enabled = 1
let g:AutoPairsFlyMode = 0
let g:AutoPairs = {}
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
let g:mix_format_on_save = 1
let g:mix_format_silent_errors = 1
nnoremap <c-a> *``

" CtrlP fuzzy finder
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"
" CoC configs
"

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


" Remap <C-h> and <C-l> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-h> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-h>"
nnoremap <nowait><expr> <C-l> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-l>"
inoremap <nowait><expr> <C-h> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-l> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

"
" fix jump forward
"

nnoremap <C-I> <C-i>

if exists("*ToggleBackground") == 0
	function ToggleBackground()
		if &background == "dark"
            set background=light
		else
            set background=dark
		endif
	endfunction

	command BG call ToggleBackground()
endif

"
" Jump between virtual lines in soft-wrapping mode
"

nmap <C-j> gj
nmap <C-k> gk

"
" Netrw
"

let g:NERDTreeHijackNetrw = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25

"
" dhall
"

let g:LanguageClient_serverCommands = {
    \ 'dhall': ['dhall-lsp-server'],
    \ }

" comment the next line to disable automatic format on save
let g:dhall_format=1

" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Required for operations modifying multiple buffers like rename.
set hidden

" Map keybinding
"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>

"
" Haskell LSP/Wingmain/Coc
"

" use [h and ]h to navigate between holes
nnoremap <silent> [h :<C-U>call CocActionAsync('diagnosticPrevious', 'hint')<CR>
nnoremap <silent> ]h :<C-U>call <SID>JumpToNextHole()<CR>

" <leader>d to perform a pattern match, <leader>n to fill a hole
nnoremap <silent> <leader>d  :<C-u>set operatorfunc=<SID>WingmanDestruct<CR>g@l
nnoremap <silent> <leader>n  :<C-u>set operatorfunc=<SID>WingmanFillHole<CR>g@l
nnoremap <silent> <leader>r  :<C-u>set operatorfunc=<SID>WingmanRefine<CR>g@l
nnoremap <silent> <leader>c  :<C-u>set operatorfunc=<SID>WingmanUseCtor<CR>g@l
nnoremap <silent> <leader>a  :<C-u>set operatorfunc=<SID>WingmanDestructAll<CR>g@l

function! s:JumpToNextHole()
  call CocActionAsync('diagnosticNext', 'hint')
endfunction

function! s:GotoNextHole()
  " wait for the hole diagnostics to reload
  sleep 500m
  " and then jump to the next hole
  normal 0
  call <SID>JumpToNextHole()
endfunction

function! s:WingmanRefine(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.refine'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestruct(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.caseSplit'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestructAll(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.splitFuncArgs'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanFillHole(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.fillHole'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanUseCtor(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.useConstructor'])
  call <SID>GotoNextHole()
endfunction

"
" LanguageTool
"

nnoremap <leader>lt :LanguageToolCheck<cr>
nnoremap <leader>lc :LanguageToolClear<cr>

"
" Resize panes
"

nnoremap <leader>, :vert resize -7<cr>
nnoremap <leader>. :vert resize +7<cr>
nnoremap <leader>; :resize -7<cr>
nnoremap <leader>' :resize +7<cr>

"
" Cyrillic support for all modes, not only insert.
" Enable/disable it with Ctrl + 6.
"

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
