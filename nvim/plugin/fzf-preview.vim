nnoremap <silent> <Leader>zp     :<C-u>FzfPreviewFromResources project_mru git<CR>
nnoremap <silent> <Leader>zgs    :<C-u>FzfPreviewGitStatus<CR>
nnoremap <silent> <Leader>zb     :<C-u>FzfPreviewBuffers<CR>
nnoremap <silent> <Leader>zB     :<C-u>FzfPreviewAllBuffers<CR>
nnoremap <silent> <Leader>zo     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
nnoremap <silent> <Leader>z<C-o> :<C-u>FzfPreviewJumps<CR>
nnoremap <silent> <Leader>zg;    :<C-u>FzfPreviewChanges<CR>
nnoremap <silent> <Leader>z/     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'"<CR>
nnoremap <silent> <Leader>z*     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          <Leader>zgr    :<C-u>FzfPreviewProjectGrep<Space>
xnoremap          <Leader>zgr    "sy:FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> <Leader>zt     :<C-u>FzfPreviewBufferTags<CR>
nnoremap <silent> <Leader>zq     :<C-u>FzfPreviewQuickFix<CR>
nnoremap <silent> <Leader>zl     :<C-u>FzfPreviewLocationList<CR>
