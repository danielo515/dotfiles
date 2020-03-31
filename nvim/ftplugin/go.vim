" Don't show whitespace, since saving will clean it up automatically anyway
set nolist
let g:go_doc_keywordprg_enabled = 0
autocmd BufWrite *.go  :call CocAction('format')

function GoSpread(source) abort
  execute a:firstline . "," . a:lastline . "normal ^yiwea:  " . a:source . "\. \<esc>\"_DpA,"
endfunction
