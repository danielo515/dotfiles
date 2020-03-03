nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode remaps
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
nmap <c-f> :Ag<Space>
nmap <leader>o     :Files<cr>
" sibling files search
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <Leader>, :Files <C-r>=expand("%:h:h")<CR>/<CR>
nnoremap <silent> <leader>b :Buffers<CR>
" search on changed files
nnoremap <silent> <Leader>g :GFiles?<CR>
nnoremap <silent> <Leader>h :History<CR>
nnoremap <silent> <Leader>pp :Commands<CR>
nnoremap <silent> <Leader>l :Lines<CR>
" Show fuzzy search on a popup
if has('nvim-0.4.0') || has("patch-8.2.0191")
    let g:fzf_layout = { 'window': {
                \ 'width': 0.9,
                \ 'height': 0.7,
                \ 'highlight': 'Comment',
                \ 'rounded': v:false } }
else
    let g:fzf_layout = { "window": "silent botright 16split enew" }
endif

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
  let l:branch = a:line
  execute 'split | terminal git checkout ' . l:branch
  call feedkeys('i', 'n')
endfunction

function! s:show_branches_fzf(bang)
  let l:current = system('git symbolic-ref --short HEAD')
  let l:current = substitute(l:current, '\n', '', 'g')
  let l:current_scaped = substitute(l:current, '/', '\\/', 'g')
  call fzf#vim#grep(
    \ "git branch -r --no-color | sed -r -e 's/^[^/]*\\///' -e '/^" . l:current_scaped . "$/d' -e '/^HEAD/d' | sort -u", 0,
    \ { 'sink': function('s:open_branch_fzf'), 'options': ['--no-multi', '--header='.l:current] }, a:bang)
endfunction
command! -bang -nargs=0 FzGCheckout call <SID>show_branches_fzf(<bang>0)
" ====================


" limit the ag search to provided dir with auto completion
function! s:ag_in(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf_layout))
  endfunction

command! -nargs=+ -complete=dir AgIn call s:ag_in(<f-args>)

