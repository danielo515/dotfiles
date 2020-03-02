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
nnoremap <leader>f :CocCommand prettier.formatFile<CR>

function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
            \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
            \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
nmap <F2> <Plug>(coc-rename)

" Suggestions tab navigation
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-j> pumvisible() ? "\<C-p>" : "\<C-j>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <leader>di :CocList diagnostics<CR>
set cmdheight=2 " Better display for messages
let g:go_def_mapping_enabled = 0 " do not let vim-go use their own goto definition
