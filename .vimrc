" plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-sensible'
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-buftabline'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'vim-scripts/indentpython.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'jpalardy/vim-slime'
"Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
Plug 'tpope/vim-markdown'
Plug 'ryanoasis/vim-devicons'
"Plug 'scrooloose/nerdcommenter'
Plug 'preservim/nerdcommenter'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'davidhalter/jedi-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Scuilion/markdown-drawer'
Plug 'mattn/emmet-vim'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'"
Plug 'turbio/bracey.vim'
Plug 'inside/vim-search-pulse'
Plug 'tpope/vim-surround'
Plug 'lilydjwg/colorizer'
call plug#end()
" }}}

"cd /mnt/c/Users/krish/
set pastetoggle=<F3>
syntax on
filetype plugin indent on
"set visualbell
set clipboard=unnamed
inoremap #! #!/usr/bin/
inoremap jk <ESC>

autocmd FileType conf vnoremap <silent> / :s/^/#/<cr>:noh<cr>
autocmd FileType conf vnoremap <silent> -/ :s/^#//<cr>:noh<cr>
autocmd FileType vim vnoremap <silent> / :s/^/"/<cr>:noh<cr>
autocmd FileType vim vnoremap <silent> -/ :s/^"//<cr>:noh<cr>
autocmd FileType sh vnoremap <silent> / :s/^/#/<cr>:noh<cr>
autocmd FileType sh vnoremap <silent> -/ :s/^#//<cr>:noh<cr>
autocmd FileType hs vnoremap <silent> / :s/^/--/<cr>:noh<cr>
autocmd FileType hs vnoremap <silent> -/ :s/^--//<cr>:noh<cr>
autocmd FileType python vnoremap <silent> / :s/^/#/<cr>:noh<cr>
autocmd FileType python vnoremap <silent> -/ :s/^#//<cr>:noh<cr>
autocmd FileType html vnoremap <silent> / :s/^/<!-- /<cr><esc>:s/$/ -->/<cr>:noh<cr>
autocmd FileType html vnoremap <silent> -/ :s/^<!-- //<cr><esc>:s/ -->.*$//<cr>:noh<cr>
autocmd FileType javascript vnoremap <silent> / :s/^/\/\/ /<cr>:noh<cr>
autocmd FileType javascript vnoremap <silent> -/ :s/^#/\/\//<cr>:noh<cr>

"autocmd FileType conf inoremap <silent> <C-/> :s/^/#/<cr>:noh<cr>
"autocmd FileType conf inoremap <silent> -<C-/> :s/^#//<cr>:noh<cr>
"autocmd FileType vim inoremap <silent> <C-/> :s/^/"/<cr>:noh<cr>
"autocmd FileType vim inoremap <silent> -<C-/> :s/^"//<cr>:noh<cr>
"autocmd FileType sh inoremap <silent> <C-/> :s/^/#/<cr>:noh<cr>
"autocmd FileType sh inoremap <silent> -<C-/> :s/^#//<cr>:noh<cr>
"autocmd FileType hs inoremap <silent> <C-/> :s/^/--/<cr>:noh<cr>
"autocmd FileType hs inoremap <silent> -<C-/> :s/^--//<cr>:noh<cr>
"autocmd FileType python inoremap <silent> <C-/> :s/^/#/<cr>:noh<cr>
"autocmd FileType python inoremap <silent> -<C-/> :s/^#//<cr>:noh<cr>
"autocmd FileType html inoremap <silent> <C-/> :s/^/<!-- /<cr><esc>:s/$/ -->/<cr>:noh<cr>
"autocmd FileType html inoremap <silent> -<C-/> :s/^<!-- //<cr><esc>:s/ -->.*$//<cr>:noh<cr>
"autocmd FileType javascript inoremap <silent> <C-/> :s/^/\/\/ /<cr>:noh<cr>
"autocmd FileType javascript inoremap <silent> -<C-/> :s/^\/\/ //<cr>:noh<cr>


nnoremap <LEADER><LEADER> <ESC>:w<CR><ESC>:so $MYVIMRC<CR>
nnoremap <LEADER>O <ESC>:vsp $MYVIMRC<CR>
nnoremap <LEADER>NO <ESC>:set number! relativenumber!<CR><ESC>:set nonu<CR>

" always show the status bar
set laststatus=2

" enable mouse
set mouse=a

" enable 256 colors
set t_Co=256
set t_ut=

" turn on line numbering
set number
set relativenumber

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set tabstop=2
set shiftwidth=2
set softtabstop=2

" set colorcolumn=80
set expandtab
" set viminfo='25,\"50,n~/.viminfo
autocmd FileType python setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2

" auto-pairs
" autocmd FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

" {{{

set path+=**
set wildmenu
set wildignore+=*.so,*.swp,*.zip,**node_modules**     " MacOSX/Linux
set hidden
let g:ctrlp_cmd = 'CtrlPBuffer'

" }}}


" indent/unindent with tab/shift-tab
nmap <Tab> >>
nmap <S-tab> <<
imap <S-Tab> <Esc><<i
vmap <Tab> >gv
vmap <S-Tab> <gv

"for i in range(65,90)
"  let c = nr2char(i)
"  exec "map \e".c." <M-".c.">"
"  exec "map! \e".c." <M-".c.">"
"endfor
"for i in range(97,122)
"  let c = nr2char(i)
"  exec "map \e".c." <M-".c.">"
"  exec "map! \e".c." <M-".c.">"
"endfor

"exec "map \eb" "<M-b>"
" Alt commands
map gw <ESC><ESC><C-w>w
map gW <ESC><ESC><C-w>W
map gb <ESC>:bn<CR>
map gB <ESC>:bp<CR>
"map gq <ESC>:bprevious<CR>:bdelete #<CR>
map g1 <ESC>:b1<CR>
map g2 <ESC>:b3<CR> 
map g3 <ESC>:b4<CR>
map g4 <ESC>:b5<CR>
map g5 <ESC>:b6<CR>
map g6 <ESC>:b7<CR>
map g7 <ESC>:b8<CR>
map g8 <ESC>:b9<CR>
map g9 <ESC>:b10<CR>
map g<Right> <ESC><C-w>>
map g<Left> <ESC><C-w><
map g<Up> <ESC><C-w>+
map g<Down> <ESC><C-w>-

" color scheme
colorscheme onedark
hi Normal ctermbg=NONE
filetype on

" lightline
set noshowmode
let g:lightline = { 'colorscheme': 'onedark' }

" code folding
set foldmethod=indent
set foldlevel=99

" remove ctrl,meta delte
imap <C-Up> <Right><Left>
imap <C-Down>  <Right><Left>
imap <C-Left>  <Right><Left>
imap <C-Right>  <Right><Left>
imap <M-Up>  <Right><Left>
imap <M-Down>  <Right><Left>
imap <M-Left>  <Right><Left>
imap <M-Right>  <Right><Left>

" wrap toggle
setlocal nowrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
endfunction

" restore place in file from previous session
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" file browser
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0
map <leader>n <ESC>:call NERDTreeToggle()<CR>
function NERDTreeToggle()
    NERDTreeTabsToggle
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
    else
        let g:nerdtree_open = 1
        wincmd p
    endif
endfunction

"function! StartUp()
"    if 0 == argc()
"        NERDTree 
"    end
"endfunction
"autocmd VimEnter * call StartUp()

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Markdown
autocmd FileType markdown set spell
function! MarkdownLevel()
  if getline(v:lnum) =~ '^# .*$'
      return ">1"
  endif
  if getline(v:lnum) =~ '^## .*$'
      return ">2"
  endif
  if getline(v:lnum) =~ '^### .*$'
      return ">3"
  endif
  if getline(v:lnum) =~ '^#### .*$'
      return ">4"
  endif
  if getline(v:lnum) =~ '^##### .*$'
      return ">5"
  endif
  if getline(v:lnum) =~ '^###### .*$'
      return ">6"
  endif
    return "=" 
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr 

" Markdown Drawer
nnoremap <Leader>md :MarkDrawer<cr>

let g:markdrawer_prefix = " " 
let g:markdrawer_goto = "o"
let g:markdrawerDelete = "D"
let g:markdrawer_width = "25"
let g:markdrawer_paste_below = "p"
let g:markdrawer_increase = "+"
let g:markdrawer_decrease = "-"
let g:markdrawer_to_delete_color = "Red"

let g:markdrawer_drawer_max_levels = 4 " max levels to display
let g:markdrawer_toc = 'index' " displays as a TOC
let g:markdrawer_toc = 'full_index' " displays as a TOC, no index reset

" Markdown Preview
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Google Chrome'
let vim_markdown_preview_github=1

" Python execution
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

"nnoremap <Leader>r :w<CR>:SlimeSend1 ./script.sh<CR>
"nnoremap <Leader>r <ESC>:w<CR>:execute 'SlimeSend1 bash' expand('%:p')<CR>
nnoremap <Leader>r <ESC>:w<CR>:execute 'SlimeSend1 ' expand('%:p')<CR>

" Bash
autocmd FileType vim map <buffer> <F9> :w<CR>:source %<CR>
autocmd FileType vim imap <buffer> <F9> <ESC>:w<CR>:source %<CR>
autocmd FileType sh map <buffer> <F9> :w<CR>:!bash %<CR>
autocmd FileType sh imap <buffer> <F9> <ESC>:w<CR>:!bash %<CR>
autocmd FileType sh nnoremap <Leader>l :SlimeSend1 clear<CR>
autocmd FileType sh vnoremap <Leader>c <ESC>:SlimeSend<CR>

"
function! SuperTab()
  let l:part = strpart(getline('.'),col('.')-2,1)
  if (l:part =~ '^\W\?$')
      return "\<Tab>"
  else
      return "\<C-n>"
  endif
endfunction


" Latex compilation
autocmd FileType tex map <buffer> <F9> :w<CR>:exec '!pdflatex' shellescape(@%, 1)<CR>
autocmd FileType tex imap <buffer> <F9> <esc>:w<CR>:exec '!pdflatex' shellescape(@%, 1)<CR>

" Goyo
"map <F11> <ESC>:Goyo<CR>


" Live Markdown Preview
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = expand('~/AppData/Roaming/Typora/themes/github.css')

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = expand('~/AppData/Roaming/Typora/themes/github.css')

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" fenced block highlighting
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'bash=sh', 'xml']
let g:markdown_minlines = 200

"------------------------------------------------------------------------------
"" slime configuration 
"------------------------------------------------------------------------------
"" always use tmux
let g:slime_target = 'tmux'
"let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1
 

" fix paste issues in ipython
let g:slime_python_ipython = 1
"
" " always send text to the top-right pane in the current tmux tab without
" asking
" let g:slime_default_config = {
"             \ 'socket_name': get(split($TMUX, ','), 0),
"             \ 'target_pane': '{top-right}' }

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings. <Leader> is \ (backslash) by default

"" map <Leader>s to start IPython
autocmd FileType python nnoremap <Leader>s :SlimeSend1 ipython3 --matplotlib<CR>
"
"" map <Leader>r to run script
autocmd FileType python nnoremap <Leader>r :w<CR>:IPythonCellRun<CR>
"
"" map <Leader>R to run script and time the execution
autocmd FileType python nnoremap <Leader>R :IPythonCellRunTime<CR>
"
"" map <Leader>c to execute the current cell
autocmd FileType python nnoremap <Leader>c :IPythonCellExecuteCellVerbose<CR>
"
"" map <Leader>C to execute the current cell and jump to the next cell
autocmd FileType python nnoremap <Leader>C :IPythonCellExecuteCellVerboseJump<CR>
"
"" map <Leader>l to clear IPython screen
autocmd FileType python nnoremap <Leader>l :IPythonCellClear<CR>
"
"" map <Leader>x to close all Matplotlib figure windows
autocmd FileType python nnoremap <Leader>x :IPythonCellClose<CR>
"
"" map [c and ]c to jump to the previous and next cell header
autocmd FileType python nnoremap [c :IPythonCellPrevCell<CR>
autocmd FileType python nnoremap ]c :IPythonCellNextCell<CR>
"
"" map <Leader>h to send the current line or current selection to IPython
autocmd FileType python nmap <Leader>h <Plug>SlimeLineSend
autocmd FileType python xmap <Leader>h <Plug>SlimeRegionSend
"
"" map <Leader>p to run the previous command
autocmd FileType python nnoremap <Leader>p :IPythonCellPrevCommand<CR>
"
"" map <Leader>Q to restart ipython
autocmd FileType python nnoremap <Leader>Q :IPythonCellRestart<CR>
"
"" map <Leader>d to start debug mode
"nnoremap <Leader>d :SlimeSend1 %debug<CR>
"
"" map <Leader>q to exit debug mode or IPython
"nnoremap <Leader>q :SlimeSend1 exit<CR>
"
"" map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
"nmap <F9> :IPythonCellInsertAbove<CR>a
autocmd FileType python nmap <F10> :IPythonCellInsertBelow<CR>a
"
"" also make <F9> and <F10> work in insert mode
autocmd FileType python imap <F9> <C-o>:IPythonCellInsertAbove<CR>
autocmd FileType python imap <F10> <C-o>:IPythonCellInsertBelow<CR>


" Jedi
let g:jedi#auto_vim_configuration = 0

let g:jedi#goto_command = "gc"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = ""
let g:jedi#goto_definitions_command = "gd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "gn"
let g:jedi#completions_command = "?"
let g:jedi#rename_command = "<F2>"

"Latex configuration using slime
autocmd Filetype latex nnoremap <Leader>r :SlimeSend1 pdflatex %<CR>

"Prettier
let g:prettier#exec_cmd_path = "~/path/to/cli/prettier"

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


" Code Auto Formater {{{

nnoremap <Leader>F :FormatCode<CR>
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

" }}}


let g:vim_search_pulse_mode = 'cursor_line'
