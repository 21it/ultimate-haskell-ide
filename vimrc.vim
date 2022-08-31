"
" BASIC CONFIGS
"

"
" => General
"

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

"
" => VIM user interface
"

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore files
set wildignore=*~,*.o,*.a,*.so,*/.git/*,*/.hg/*,*/.svn/*,*/node_modules/*,*/dist-newstyle/*,*/build/*,*/_build/*,*/_cache/*,*/_site/*

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"
" => Colors and Fonts
"

" Enable syntax highlighting
syntax enable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"
" => Files, backups and undo
"

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set noswapfile
set nowritebackup

"
" => Text, tab and indent related
"

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"
" => Visual mode related
"

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"
" => Moving around, tabs, windows and buffers
"

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"
" => Status line
"

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

"
" => Editing mappings
"

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"
" => Spell checking
"

" Toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"
" => Misc
"

" Quickly open a markdown buffer for scribble
map <leader>z :e ~/.ultimate-haskell-ide/notes.md<cr>

"
" => Helper functions
"

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"
" PLUGIN CONFIGS
"

"
" => Load pathogen paths
"

let s:vim_runtime = expand('<sfile>:p:h')."/."
call pathogen#infect(s:vim_runtime.'/src/{}')
call pathogen#helptags()

"
" => CTRL-P
"

let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<C-f>'
map <leader>j :CtrlP<cr>
map <C-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = '^\.git\|^\.hg\|^\.svn\|node_modules\|dist-newstyle\|build\|_build\|_cache\|_site'

"
" => lightline
"

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }

"
" EXTENDED CONFIGS
"

"
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"

try
    set undodir=~/.ultimate-haskell-ide/tmp/undodir
    set undofile
catch
endtry

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"
" => Parenthesis/bracket
"

vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i

"
" => Omni complete functions
"

autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" When you search with Ack, toggle your results in cope by doing:
"   <M-f>
"
" To go to the next search result do:
"   <M-n>
"
" To go to the previous search results do:
"   <M-p>
"
let g:toggle_list_no_mappings = 1
map <M-f> :call ToggleQuickfixList()<cr>
map <M-n> :cn<cr>
map <M-p> :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"
" CUSTOM CONFIGS
"

"
" => Colors, style and theme
"

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

if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif

syntax on
set t_Co=256
exe 'set background=' . get(g:, "vimBackground", "light")
exe 'colorscheme ' . get(g:, "vimColorScheme", "PaperColor")
exe 'let g:languagetool_jar=' . get(g:, "languagetool_jar", "$LANGUAGE_TOOL_JAR")
let g:languagetool_disable_rules="DASH_RULE,WHITESPACE_RULE,EN_QUOTES"
set colorcolumn=67
nnoremap <silent> <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
nnoremap <space> <Nop>
let mapleader = " "
set splitright
let vim_markdown_preview_toggle=1
let vim_markdown_preview_hotkey='<C-p>'
let vim_markdown_preview_browser='Firefox'
let vim_markdown_preview_temp_file=1
let vim_markdown_preview_github=1
let vim_markdown_preview_use_xdg_open=1
let vim_markdown_folding_disabled = 1
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help']
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairs = {}
nnoremap <c-a> *``
"autocmd VimEnter * :vs | :te
"autocmd VimEnter * :vert resize -14

" Sideways plugin to move text using ALT+[hl]
nmap <M-h> :SidewaysLeft<cr>
nmap <M-l> :SidewaysRight<cr>
vmap <M-h> :SidewaysLeft<cr>
vmap <M-l> :SidewaysRight<cr>

" CtrlP fuzzy finder
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"
" => CoC configs
"

" Required for operations modifying multiple buffers like rename.
" If hidden is not set, TextEdit might fail.
set hidden

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Always draw sign column. Prevent buffer moving when adding/deleting sign.
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
nnoremap <silent> <leader>ca  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current dcocument
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Search workspace symbolsc
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
" Do default action for necxt item.
nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
" Do default action for prcevious item.
nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>cp  :<C-u>CocListResume<CR>

" Remap <C-h> and <C-l> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-h> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-h>"
nnoremap <nowait><expr> <C-l> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-l>"
inoremap <nowait><expr> <C-h> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-l> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

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
" => Jump between virtual lines in soft-wrapping mode
"

nmap <C-j> gj
nmap <C-k> gk

"
" => Netrw
"

let g:netrw_liststyle = 3

"
" => Dhall
"

let g:LanguageClient_serverCommands = {
    \ 'dhall': ['dhall-lsp-server'],
    \ }

" Comment the next line to disable automatic format on save.
let g:dhall_format=1

"
" => Haskell LSP/Wingmain/Coc
"

" Disable Yesod mappings because I'm not using them much anyway.
" Maybe should reseach how useful Yesod plugin mappings are.
let g:yesod_disable_maps = 1

" Wingman mappings
nnoremap <silent> <leader>wp :<C-U>call CocActionAsync('diagnosticPrevious', 'hint')<CR>
nnoremap <silent> <leader>wn :<C-U>call <SID>JumpToNextHole()<CR>

nnoremap <silent> <leader>wd  :<C-u>set operatorfunc=<SID>WingmanDestruct<CR>g@l
nnoremap <silent> <leader>wf  :<C-u>set operatorfunc=<SID>WingmanFillHole<CR>g@l
nnoremap <silent> <leader>wr  :<C-u>set operatorfunc=<SID>WingmanRefine<CR>g@l
nnoremap <silent> <leader>wc  :<C-u>set operatorfunc=<SID>WingmanUseCtor<CR>g@l
nnoremap <silent> <leader>wa  :<C-u>set operatorfunc=<SID>WingmanDestructAll<CR>g@l

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
" => LanguageTool
"

"nnoremap <leader>lt :LanguageToolCheck<cr>
"nnoremap <leader>lc :LanguageToolClear<cr>

"
" => Resize panes
"

nnoremap <leader>, :vert resize -7<cr>
nnoremap <leader>. :vert resize +7<cr>
nnoremap <leader>; :resize -7<cr>
nnoremap <leader>' :resize +7<cr>

"
" => Cyrillic support for all modes, not only insert.
" Enable/disable it with Ctrl + 6.
"

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

"
" => Some stuff for terminal mode
"

tnoremap <esc> <C-\><C-n>

"
" => Tabs shortcuts
"

nnoremap <leader>j :tabprev<cr>
nnoremap <leader>k :tabnext<cr>
nnoremap <leader>h :tabfirst<cr>
nnoremap <leader>l :tablast<cr>
nnoremap <leader>t :tabnew<cr>
nnoremap <leader>e :tabnew \| startinsert \| term<cr>
nnoremap <leader>x :tabclose<cr>
nnoremap <leader>o :tabonly<cr>
