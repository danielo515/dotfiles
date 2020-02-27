let s:local_path = expand('<sfile>:p:h')
function! ComboRead(targetKey)
  let keyList = input("Key list space separated\n ")
  let cmd = s:local_path."/combo.js ".a:targetKey." ".keyList
  let @a = system(cmd)
  echo "\nGenerated combo: \n" . @a
endfunction

