nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode remaps
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" Search and search in local dir
nmap <c-f> :Ag<Space>
nmap <c-f><c-f> :AgDir<Space>
nmap <leader>o     :Files<cr>
" sibling files search
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <Leader>, :Files <C-r>=expand("%:h:h")<CR>/<CR>
nnoremap <silent> <leader>b :FzfPreviewBuffers<CR>
nnoremap <silent> <c-b> :Buffers<CR>
" search on changed files
nnoremap <silent> <Leader>h :History<CR>
nnoremap <silent> <Leader>pp :Commands<CR>
nnoremap <silent> <Leader>l :Lines<CR>
" Show fzf on a popup
if has('nvim-0.4.0') || has("patch-8.2.0191")
    let $FZF_DEFAULT_OPTS = '--layout=reverse'
    let g:fzf_layout = { 'window': {
                \ 'width': 0.9,
                \ 'height': 0.7,
                \ 'highlight': 'Comment',
                \ 'rounded': v:false } }
else
    let g:fzf_layout = { "window": "silent botright 16split enew" }
endif
" files window with preview
command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Custom colors to match theme
let g:fzf_colors = {
\   'bg+':     ['bg', 'Normal'],
\   'fg+':     ['fg', 'Statement'],
\   'hl':      ['fg', 'Underlined'],
\   'hl+':     ['fg', 'Underlined'],
\   'info':    ['fg', 'MatchParen'],
\   'pointer': ['fg', 'Special'],
\   'prompt':  ['fg', 'Normal'],
\   'marker':  ['fg', 'MatchParen']
\ }
"========== use fzf to checkout branches!
" Stolen from https://github.com/stsewd/dotfiles/blob/7a9a8972c8a994abf42d87814980dc92cdce9a22/config/nvim/init.vim#L419-L434
function! s:open_branch_fzf(line)
  let l:parser = split(a:line)
  let l:branch = l:parser[0]
  if l:branch ==? '*'
    let l:branch = l:parser[1]
  endif
  execute '!git checkout ' . l:branch
endfunction
" Command
command! -bang -nargs=0 GCheckout
  \ call fzf#vim#grep(
  \   'git branch -v', 0,
  \   {
  \     'sink': function('s:open_branch_fzf')
  \   },
  \   <bang>0
  \ )
" ====================
" ==================== fzf for deleting buffers!
function! Bufs()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': Bufs(),
  \ 'sink*': { lines -> execute('bwipeout '.join(map(lines, {_, line -> split(line)[0]}))) },
  \ 'options': '--multi --bind ctrl-a:select-all+accept'
\ }))
"=========================

" limit the ag search to provided dir with auto completion
function! s:ag_in(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf_layout))
  endfunction

"Search in a directory
command! -nargs=+ -complete=dir AgIn call s:ag_in(<f-args>)
"Search on the current directory
command! -nargs=+ AgDir call s:ag_in(expand("%:p:h"),<f-args>)

