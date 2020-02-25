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
                              \'https://github.com/xabikos/vscode-javascript',
                              \]
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

nmap [e <Plug>(coc-diagnostic-prev-error)
nmap ]e <Plug>(coc-diagnostic-next-error)

nmap <leader>f <Plug>(coc-fix-current)
