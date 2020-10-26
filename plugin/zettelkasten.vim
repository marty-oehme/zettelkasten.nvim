" for DEBUGGING ONLY: reloads the whole lua plugin
fun! ZKReload()
  lua for k in pairs(package.loaded) do if k:match("^zettelkasten")  then package.loaded[k] = nil end end
  lua require 'zettelkasten'.init()
endfun
nnoremap <leader>R :call ZKReload()<cr>

augroup Zettelkasten
  autocmd!
augroup END

" nnoremap <Plug>Zettel_Link :call zettelkasten#zettel_link()<cr>
nnoremap <Plug>zettel_link_create :lua require 'zettelkasten'.zettel_link_create()<cr>

nmap <leader>n <Plug>zettel_link_create
