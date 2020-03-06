" Section: Remaps {{{1
let vimrc_path = expand('<sfile>:p:h')
" source a vimrc file
nnoremap <expr> <leader>so ":source " . vimrc_path
nnoremap <leader>si :w<CR>:source %
" edit vimrc stuff
nnoremap <expr> <leader>ve ":e " . vimrc_path
" Disable arrow movement, resize splits instead.
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" Tab Shortcuts
nnoremap tk :tabfirst<CR>
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tj :tablast<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :CtrlSpaceTabLabel<CR>
nnoremap td :tabclose<CR>
nnoremap bd :bd<CR>
set completeopt-=preview

nnoremap <leader>w :wa<CR>
nnoremap <leader>ww :wq<CR>
nmap <Tab> :bnext<CR>
nmap <c-j><c-j> :bprev<CR>

" insert line behind below and split line
nnoremap <leader>j o<Esc>
nnoremap <leader>k O<Esc>
"split at cursor position
nnoremap <leader><CR> i<cr><esc>

" Ranger file explorer
let g:ranger_map_keys = 0
nnoremap <leader>rr :Ranger<CR>

" Git related
nnoremap <leader>ga :Git add . <CR>
nnoremap <leader>gg :w<CR>:Git add .<CR>:Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <Leader>gs :tabnew<bar>leftabove vertical Gstatus<CR>
nnoremap <leader>xs :tab Gstatus<bar>botright vsplit<CR>
nnoremap <leader>gc :GCheckout<CR>

" Windows equal size
nnoremap <leader>we <C-w>=

" Plug instlall
nnoremap <leader>pi :w<CR>:so $MYVIMRC<CR>:PlugInstall<CR>
" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cf :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
" This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cf :let @*=expand("%")<CR>
  nmap ,cp :let @*=expand("%:p")<CR>
endif
"==================== Ide like mappings
" Mirror of cmd+p
nnoremap <c-q> :Commands<cr>
" faster clipboard copying/pastig
nnoremap <leader>y "*y
nnoremap <leader>Y "+Y
nnoremap <leader>p "*p
nnoremap <leader>P "+P
" Easy motion
" Sneak like
nmap s <Plug>(easymotion-s2)
" buffer delete from fzf
nnoremap <leader>bd :BD<cr>
" ====================
" json annotate for go
nnoremap <leader>ja :normal ^yiwA `json:""<Esc>P<CR>
