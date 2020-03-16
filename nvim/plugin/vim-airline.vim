let g:airline_section_x = '%{PencilMode()}'

" Configure the Tabline

let g:airline#extensions#neomake#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 1 " enable/disable displaying buffers with a single tab
let g:airline#extensions#tabline#show_splits = 1 "enable/disable displaying open splits per tab (only when tabs are opened). >
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
