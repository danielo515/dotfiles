if !exists("g:danielo_wich_key")
  let g:danielo_wich_key = 1
  autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")
endif

" By default timeoutlen is 1000 ms
set timeoutlen=500
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" Define prefix dictionary
let g:which_key_map =  {}

" Second level dictionaries:
" 'name' is a special field. It will define the name of the group, e.g., leader-f is the "+file" group.
" Unnamed groups will show a default empty string.

" =======================================================
" Create menus based on existing mappings
" Mappings are defined on the keymaps.vim file
" =======================================================
" You can pass a descriptive text to an existing mapping.

let g:which_key_map.g = { 'name' : '+git' }
let g:which_key_map.g.a = 'git add all'
let g:which_key_map.g.g = 'git commit current file'
let g:which_key_map.g.p = 'git push'
let g:which_key_map.g.s = 'git status'
let g:which_key_map.g.c = 'git gheckout with fzf'
let g:which_key_map.f = { 'name' : '+file' }

nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'

nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
let g:which_key_map.f.d = 'open-vimrc'

let g:which_key_map.f.c = {'name': '+copy'}
let g:which_key_map.f.c.f = 'copy relative path'
let g:which_key_map.f.c.p = 'copy full path'
let g:which_key_map.f.v = 'edit vimrc plugin'
" let g:which_key_map.w.e = 'equal windows'
