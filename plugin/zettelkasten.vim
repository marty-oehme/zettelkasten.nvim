fun! ZKReload()
  " for DEBUGGING
  lua for k in pairs(package.loaded) do if k:match("^zettelkasten")  then package.loaded[k] = nil end end
  echom 'zettelkasten reloaded'
  lua require 'zettelkasten'.init()
endfun

augroup Zettelkasten
  autocmd!
augroup END

" nnoremap <Plug>Zettel_Link :call zettelkasten#zettel_link()<cr>
nnoremap <Plug>Zettel_Link :lua require 'zettelkasten'.zettel_link()<cr>

nmap <leader>p <Plug>Zettel_Link
