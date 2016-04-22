" Section: General Config {{{1
" ----------------------------
let mapleader = " "
let &runtimepath .= "," . $DOTFILES . "/nvim"  " Add DOTFILES to runtimepath

set shell=zsh " Set bash as the prompt for Vim
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set noshowmode
set timeoutlen=1000
set ttimeoutlen=0
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set scrolloff=3
set list listchars=tab:»·,trail:·  " Display extra whitespace characters

" Line numbers
set number
set numberwidth=5

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Highlight search matches
set hlsearch

" Make it obvious where 80 characters is {{{2
" Lifted from StackOverflow user Jeremy W. Sherman
" http://stackoverflow.com/a/3765575/2250435
if exists('+colorcolumn')
  set textwidth=80
  set colorcolumn=+1
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif " }}}2

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" }}}1
" Section: Autocommands {{{1
" --------------------------
if has("autocmd")
  filetype plugin indent on

  autocmd BufReadPost * " {{{2
    " When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif "}}}2

  " Automatically clean trailing whitespace
  autocmd BufWritePre * :%s/\s\+$//e

  autocmd BufRead,BufNewFile COMMIT_EDITMSG call pencil#init({'wrap': 'soft'})
                                        \ | set textwidth=0

  autocmd BufRead,BufNewFile *.md set filetype=markdown

  autocmd BufRead,BufNewFile .eslintrc,.jscsrc,.jshintrc,.babelrc set ft=json

endif
" }}}1
" Section: External Functions {{{

" Open folder in finder {{{
function! OpenInFinder()
  call system('open ' . getcwd())
endfunction
nnoremap <leader>f :call OpenInFinder()<CR>
" }}}
" Open current file in Marked {{{
function! MarkedPreview()
  :w
  exec ':silent !open -a "Marked 2.app" ' . shellescape('%:p')
  redraw!
endfunction
nnoremap <leader>md :call MarkedPreview()<CR>
" }}}
" Open current repo in Tower {{{
function! OpenInGitTower()
  call system('gittower ' . getcwd())
endfunction
nnoremap <leader>gt :call OpenInGitTower()<CR>
" }}}
" Open current directory in Atom {{{
function! OpenInAtom()
  :w
  exec ':silent !atom ' . shellescape('%:p')
  redraw!
endfunction
nnoremap <leader>a :call OpenInAtom()<CR>
" }}}
" }}}
" Section: Load vim-plug plugins {{{

" Load plugins {{{2
call plug#begin()

" UI
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'            " Handy info
Plug 'retorillo/airline-tablemode.vim'
Plug 'edkolev/tmuxline.vim'               " Make the Tmux bar match Vim
Plug 'ryanoasis/vim-webdevicons'
Plug 'junegunn/goyo.vim'

" Project Navigation
Plug 'junegunn/fzf',                      { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree',               { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/ctags.vim'              " ctags related stuff
Plug 'majutsushi/tagbar'

" File Navigation
Plug 'vim-scripts/matchit.zip'            " More powerful % matching
Plug 'Lokaltog/vim-easymotion'            " Move like the wind!
Plug 'jeffkreeftmeijer/vim-numbertoggle'  " Smarter line numbers
Plug 'wellle/targets.vim'
Plug 'kshenoy/vim-signature'
Plug 'haya14busa/incsearch.vim'           " Better search highlighting
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

" Editing
Plug 'tpope/vim-surround'                 " Change word surroundings
Plug 'tpope/vim-commentary'               " Comments stuff
Plug 'dhruvasagar/vim-table-mode',        { 'on': 'TableModeEnable' }
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'jasonlong/vim-textobj-css'

" Git
Plug 'tpope/vim-fugitive'                 " Git stuff in Vim
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim',                   { 'on': 'GV' }

" Task Running
Plug 'tpope/vim-dispatch'                 " Run tasks asychronously in Tmux
Plug 'benekastah/neomake'                 " Run tasks asychronously in NeoVim
Plug 'wincent/terminus'
Plug 'christoomey/vim-tmux-navigator'

" Autocomplete
Plug 'Shougo/deoplete.nvim',              { 'do': function('hooks#remote') }
Plug 'zchee/deoplete-jedi'
Plug 'carlitux/deoplete-ternjs'
Plug 'SirVer/ultisnips',                  { 'do': function('hooks#remote') }

" Misc.
Plug 'editorconfig/editorconfig-vim'
Plug 'rizzatti/dash.vim'

" Language-Specific Plugins
Plug 'pangloss/vim-javascript',           { 'for': 'javascript' }
Plug 'mxw/vim-jsx',                       { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax',      { 'for': 'javascript' }
Plug 'ternjs/tern_for_vim',               { 'do': 'npm install' }
Plug 'rhysd/npm-debug-log.vim'
Plug '~/projects/vim-plugins/vim-ember-cli'
Plug 'reedes/vim-pencil'                  " Markdown, Writing
Plug 'vim-ruby/vim-ruby',                 { 'for': 'ruby' }
Plug 'tpope/vim-endwise',                 { 'for': 'ruby' }
Plug 'wellbredgrapefruit/tomdoc.vim',     { 'for': 'ruby' }
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'mattn/emmet-vim'
Plug 'wting/rust.vim',                    { 'for': 'rust' }
Plug 'cespare/vim-toml'
Plug 'mustache/vim-mustache-handlebars'
Plug 'groenewege/vim-less',               { 'for': 'less' }
Plug 'cakebaker/scss-syntax.vim',         { 'for': 'scss' }
Plug 'fatih/vim-go',                      { 'for': 'go' }
Plug 'godlygeek/tabular',                 { 'for': 'markdown' } " Needed for vim-markdown
Plug 'plasticboy/vim-markdown',           { 'for': 'markdown' }
Plug 'bpdp/vim-java',                     { 'for': 'java' }
Plug 'adragomir/javacomplete',            { 'for': 'java' }
Plug 'klen/python-mode',                  { 'for': 'python' }
Plug 'davidhalter/jedi-vim',              { 'for': 'python' }
Plug 'alfredodeza/pytest.vim',            { 'for': 'python' }
Plug 'elixir-lang/vim-elixir'

Plug 'neovim/node-host',                  { 'do': 'npm install' }

call plug#end()
" }}}2
" Load plugin configurations {{{2
function! PluginConfig(filename)
  let l:filename = "plugin_config/" . a:filename . ".vim"
  exec "runtime " . l:filename
endfunction

augroup vimrcEx
  autocmd!
  call PluginConfig("deoplete")
  call PluginConfig("gruvbox")
  call PluginConfig("emmet-vim")
  call PluginConfig("fzf")
  call PluginConfig("goyo")
  call PluginConfig("incsearch")
  call PluginConfig("jedi-vim")
  call PluginConfig("neomake")
  call PluginConfig("nerdtree")
  call PluginConfig("pytest.vim")
  call PluginConfig("python-mode")
  call PluginConfig("tagbar")
  call PluginConfig("tern")
  call PluginConfig("ultisnips")
  call PluginConfig("vim-airline")
  call PluginConfig("vim-go")
  call PluginConfig("vim-jsx")
  call PluginConfig("vim-markdown")
  call PluginConfig("vim-mustache-handlebars")
  call PluginConfig("vim-pencil")
  call PluginConfig("vim-rails")
  call PluginConfig("vim-table-mode")
augroup END " }}}2
" }}}1
" Section: Remaps {{{1

" Normal Mode Remaps {{{2

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Smarter pasting
nnoremap <Leader>p :set invpaste paste?<CR>

" -- Smart indent when entering insert mode with i on empty lines --------------
function! IndentWithI()
  if len(getline('.')) == 0
    return "\"_ddO"
  else
    return "i"
  endif
endfunction
nnoremap <expr> i IndentWithI()

" Tab Shortcuts {{{3
nnoremap <C-t>n  :tabnew<CR>
nnoremap <C-t>l  :tabnext<CR>
nnoremap <C-t>h  :tabprevious<CR>
nnoremap <C-t>c  :tabclose<CR>
" }}3
" }}}2
" Insert Mode Remaps {{{2

set completeopt-=preview
function! InsertTabWrapper()
  let col = col('.') - 1
  if pumvisible()
    return "\<C-n>"
  elseif !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return deoplete#mappings#manual_complete()
  endif
endfunction
inoremap <silent> <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <silent><expr> <S-Tab>
  \ pumvisible() ? '<C-p>' : ''

" }}}2
" }}}1
" Section: Theme {{{

syntax enable
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set background=dark
colorscheme gruvbox

" Setup Terminal Colors For Neovim {{{
if has('nvim')
  " dark0 + gray
  let g:terminal_color_0 = "#282828"
  let g:terminal_color_8 = "#928374"

  " neurtral_red + bright_red
  let g:terminal_color_1 = "#cc241d"
  let g:terminal_color_9 = "#fb4934"

  " neutral_green + bright_green
  let g:terminal_color_2 = "#98971a"
  let g:terminal_color_10 = "#b8bb26"

  " neutral_yellow + bright_yellow
  let g:terminal_color_3 = "#d79921"
  let g:terminal_color_11 = "#fabd2f"

  " neutral_blue + bright_blue
  let g:terminal_color_4 = "#458588"
  let g:terminal_color_12 = "#83a598"

  " neutral_purple + bright_purple
  let g:terminal_color_5 = "#b16286"
  let g:terminal_color_13 = "#d3869b"

  " neutral_aqua + faded_aqua
  let g:terminal_color_6 = "#689d6a"
  let g:terminal_color_14 = "#8ec07c"

  " light4 + light1
  let g:terminal_color_7 = "#a89984"
  let g:terminal_color_15 = "#ebdbb2"
endif " }}}
" }}}
" Section: Local-Machine Config {{{

if filereadable($DOTFILES . "/nvim/init.local.vim")
  source $DOTFILES/nvim/init.local.vim
endif
" }}}
