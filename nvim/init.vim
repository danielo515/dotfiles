" Section: General Config {{{1
" ----------------------------
let mapleader = " "
let &runtimepath .= "," . $DOTFILES . "/nvim"  " Add DOTFILES to runtimepath
let &packpath .= "," . $DOTFILES . "/nvim"

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
set hidden
set inccommand=nosplit

" Line numbers
set number
set numberwidth=5

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Highlight search matches
set hlsearch

" Make it obvious where 120 characters is {{{2
" Lifted from StackOverflow user Jeremy W. Sherman
" http://stackoverflow.com/a/3765575/2250435
if exists('+colorcolumn')
  set textwidth=120
  set colorcolumn=+1
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>120v.\+', -1)
endif " }}}2
" Open new split panes to right and bottom, which feels more natural {{{2
set splitbelow
set splitright
" }}}2
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

  "autocmd BufRead,BufNewFile COMMIT_EDITMSG call pencil#init({'wrap': 'soft'})
  "     \ | set textwidth=0

  autocmd BufRead,BufNewFile *.md set filetype=markdown

  autocmd BufRead,BufNewFile .eslintrc,.jscsrc,.jshintrc,.babelrc set ft=json

  autocmd BufRead,BufNewFile gitconfig set ft=.gitconfig

  au! BufRead,BufNewFile *.tsx       setfiletype typescript
endif
" }}}1
" Section: External Functions {{{

" }}}
" Section: Load vim-plug plugins {{{

" Specify plugins {{{2
call plug#begin()

" UI {{{3
Plug 'trevordmiller/nova-vim'
Plug 'vim-airline/vim-airline'            " Handy info
Plug 'retorillo/airline-tablemode.vim'
Plug 'edkolev/tmuxline.vim'               " Make the Tmux bar match Vim
Plug 'ryanoasis/vim-webdevicons'
Plug 'mklabs/split-term.vim'

" Project Navigation {{{3
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf',                      { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'vim-scripts/ctags.vim'              " ctags related stuff
Plug 'majutsushi/tagbar'
Plug 'rbgrouleff/bclose.vim'              " Required by ranger.vim
Plug 'francoiscabrol/ranger.vim'
Plug 'antoinemadec/coc-fzf'

" File Navigation {{{3
Plug 'vim-scripts/matchit.zip'            " More powerful % matching
Plug 'Lokaltog/vim-easymotion'            " Move like the wind!
Plug 'jeffkreeftmeijer/vim-numbertoggle'  " Smarter line numbers
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'           " Better search highlighting

" Editing {{{3
Plug 'tpope/vim-surround'                 " Change word surroundings
Plug 'tpope/vim-commentary'               " Comments stuff
Plug 'tpope/vim-repeat'
Plug 'dhruvasagar/vim-table-mode',        { 'on': 'TableModeEnable' }
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'jasonlong/vim-textobj-css'
Plug 'editorconfig/editorconfig-vim'

" Git
Plug 'tpope/vim-fugitive'                 " Git stuff in Vim
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim',                   { 'on': 'GV' }
Plug 'jez/vim-github-hub'
Plug 'rhysd/committia.vim'
Plug 'APZelos/blamer.nvim'
" Blame on vim startup
let g:blamer_enabled = 1
" Task Running
Plug 'tpope/vim-dispatch'                 " Run tasks asychronously in Tmux
Plug 'w0rp/ale'                           " Linter
Plug 'wincent/terminus'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Olical/vim-enmasse'                 " Edit all files in a Quickfix list
Plug 'janko-m/vim-test'

" Autocomplete {{{3
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Language Support {{{3
" JavaScript {{{4
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'rhysd/npm-debug-log.vim'

" TypeScript {{{4
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript',       { 'do': ':UpdateRemotePlugins' }

" Elm {{{4
"Plug 'ElmCast/elm-vim'

" HTML {{{4
Plug 'othree/html5.vim',                  { 'for': 'html' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'mattn/emmet-vim'

" CSS {{{4
Plug 'hail2u/vim-css3-syntax',            { 'for': 'css' }

" Sass {{{4
Plug 'cakebaker/scss-syntax.vim'

" VIM
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'


" Python {{{4
Plug 'klen/python-mode',                  { 'for': 'python' }
Plug 'davidhalter/jedi-vim',              { 'for': 'python' }
Plug 'alfredodeza/pytest.vim',            { 'for': 'python' }

" Rust {{{4
Plug 'wellbredgrapefruit/tomdoc.vim',     { 'for': 'ruby' }
Plug 'wting/rust.vim'
Plug 'cespare/vim-toml'

" Go {{{4
Plug 'fatih/vim-go'
" Plug 'nsf/gocode',                        { 'rtp': 'nvim', 'do': './nvim/symlink.sh' }

" Markdown {{{4
Plug 'reedes/vim-pencil'                  " Markdown, Writing
Plug 'godlygeek/tabular',                 { 'for': 'markdown' } " Needed for vim-markdown
Plug 'plasticboy/vim-markdown',           { 'for': 'markdown' }
" Docker
Plug 'ekalinin/dockerfile.vim'
Plug 'jparise/vim-graphql'
" Elixir {{{4
"Plug 'elixir-editors/vim-elixir'
"Plug 'slashmili/alchemist.vim'

call plug#end()
" Load plugin configurations {{{2
" For some reason, a few plugins seem to have config options that cannot be
" placed in the `plugins` directory. Those settings can be found here instead.


" This needs to live here or it will not work
let g:airline_powerline_fonts = 1 " Enable the patched Powerline fonts
" emmet-vim {{{3
let g:user_emmet_leader_key='<C-E>'

let g:user_emmet_settings = {
      \    'html' : {
      \        'quote_char': "'"
      \    }
      \}
" }}}3

" ranger.vim {{{3
let g:ranger_replace_netrw = 1 " open ranger when vim open a directory

" }}}2
" }}}1
" Section: Theme {{{

syntax enable
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
set background=dark
colorscheme darkblue
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
" DANIELO customizations
" Built in tree file configuration
 let g:netrw_liststyle = 3 " Width tree
 let g:netrw_winsize = 15 " 15% of editor size
 let g:netrw_browse_split = 4 " Open file on existing window
" Terminal splitting
" Javascript
let g:javascript_plugin_jsdoc = 1
set nofoldenable
set scrolloff=50
" Both required for intuitive search
set ignorecase
set smartcase

