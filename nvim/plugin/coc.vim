let g:coc_global_extensions = ['coc-tsserver',
                              \'coc-json',
                              \'coc-css' ,
                              \'coc-python',
                              \'coc-yaml',
                              \'coc-highlight',
                              \'coc-emmet',
                              \'coc-lists',
                              \'coc-git',
                              \'coc-yank',
                              \'coc-markdownlint',
                              \'coc-gitignore',
                              \'coc-pairs',
                              \'coc-sh',
                              \'coc-terminal',
                              \'coc-docker',
                              \'coc-github',
                              \'coc-snippets',
                              \'coc-prettier',
                              \'coc-html',
                              \'coc-flow',
                              \'coc-vimlsp',
                              \'https://github.com/xabikos/vscode-javascript',
                              \'https://github.com/danielo515/vscode-node-snippets',
                              \'https://github.com/andys8/vscode-jest-snippets',
                              \'https://github.com/dsznajder/vscode-es7-javascript-react-snippets',
                              \]


nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-references)

nmap [e <Plug>(coc-diagnostic-prev-error)
nmap ]e <Plug>(coc-diagnostic-next-error)

nmap <leader>fx <Plug>(coc-fix-current)
vmap <leader>f  <Plug>(coc-format-selected)
nnoremap <leader>ff :CocCommand prettier.formatFile<CR>

nmap <F2> <Plug>(coc-rename)
nnoremap <leader>c :<C-u>CocFzfList<cr>
" Diagnostics for the currnt file and the whole repo
nnoremap <leader>di :CocFzfList diagnostics --current-buf<CR>
nnoremap <leader>dia :CocFzfList diagnostics<CR>
let g:go_def_mapping_enabled = 0 " do not let vim-go use their own goto definition
" ========================= Not my customizations
function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
            \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
"==============================
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><C-j> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
"=========================
" Coc actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
