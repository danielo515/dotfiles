" Section: Remaps {{{1
let s:vimrc_path = expand('<sfile>:p:h:h')
function! s:get_vimrc_path()
      return s:vimrc_path
endfunction
" source a vimrc file
nnoremap <expr> <leader>so ":source " . <SID>get_vimrc_path()
nnoremap <leader>si :w<CR>:source %<CR>
" edit vimrc stuff with fzf
nnoremap <leader>fv :call fzf#run({'options': '--reverse --prompt "VimFiles"', 'down': 20, 'dir': <SID>get_vimrc_path(), 'sink': 'e' })<CR>
" Disable arrow movement, resize splits instead.
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

nnoremap <c-s> :%s/

" Tab Shortcuts
nnoremap tk :tabfirst<CR>
nnoremap tl :tab<CR>
nnoremap th :tabprev<CR>
nnoremap tj :tablast<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :CtrlSpaceTabLabel<CR>
nnoremap td :tabclose<CR>
set completeopt-=preview

nnoremap <leader>w :wa<CR>
nmap <Tab> :bnext<CR>
nmap <c-j><c-j> :bprev<CR>

" insert line behind below and split line
nnoremap zj o<Esc>
nnoremap zk O<Esc>
"split at cursor position
nnoremap zi i<cr><esc>

" Git related
nnoremap <leader>ga :Git add . <CR>
nnoremap <silent> <leader>gg :Gcommit %<CR>
nnoremap <silent> <leader>gaf :Git add %<bar>Git commit --amend<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <Leader>gs :tabnew<bar>leftabove vertical Gstatus<CR>
nnoremap <leader>gc :GCheckout<CR>

" Windows equal size
nnoremap <leader>we <C-w>=

" Plug instlall
nnoremap <leader>pi :w<CR>:so $MYVIMRC<CR>:PlugInstall<CR>
" Convert slashes to backslashes for Windows.
if has('win32')
  nmap <leader>fcf :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap <leader>fcp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
" This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap <leader>fc8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap <leader>fcf :let @*=expand("%")<CR>
  nmap <leader>fcp :let @*=expand("%:p")<CR>
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
nmap s <Plug>(easymotion-sn)
vmap s <Plug>(easymotion-sn)
nmap mw <Plug>(easymotion-bd-w)
nmap me <Plug>(easymotion-bd-e)
nmap ml <Plug>(easymotion-bd-jk)
" buffer delete from fzf
nnoremap <leader>bd :BD<cr>

nnoremap <leader>ju :FzfPreviewJumps<cr>
"Delete current buffer without closing the window
command! Bd :bp<bar>bd#<cr>
" Delete all buffers except current one
command! BOnly :up | %bd | e#

" COC explorer
:nmap <leader>e :CocCommand explorer<CR>

" Cut texts to a cycling number of registers
let g:regCount = 1
function CutText(textObject)
  let buffers = ["a", "s", "d", "f", "g"]
  let g:regCount += 1
  let g:regCount %= 5
  echo "Using ".buffers[g:regCount]
  return 'normal "' . buffers[g:regCount] . "d" . a:textObject
endfunction
nnoremap <leader>dw :execute CutText("iw")<CR>
nnoremap <leader>d$ :execute CutText("$")<CR>
