" TODO for DEBUGGING ONLY: reloads the whole lua plugin
fun! ZKReload()
  lua for k in pairs(package.loaded) do if k:match("^zettelkasten")  then package.loaded[k] = nil end end
  lua require 'zettelkasten'
endfun
nnoremap <leader>R :call ZKReload()<cr>

augroup Zettelkasten
  autocmd!
augroup END

command! ZKOpen lua require('zettelkasten').open_link()

command! -range ZKCreate lua require('zettelkasten').create_link()

" example plug mappings
" nnoremap <Plug>Zettel_Link :call zettelkasten#zettel_link()<cr>
map <leader>i <Plug>zettel_link_open

map <cr> <Plug>zettel_link_follow
