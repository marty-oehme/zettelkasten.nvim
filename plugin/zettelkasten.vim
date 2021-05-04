" TODO remove after debugging
if exists('g:loaded_zettelkasten')
  finish
endif
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
nnoremap <Plug>zettel_link_open :lua require 'zettelkasten'.open_link()<cr>
vnoremap <Plug>zettel_link_open :lua require 'zettelkasten'.open_link()<cr>
nmap <leader>i <Plug>zettel_link_open
vmap <leader>i <Plug>zettel_link_open

nnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.make_link()<cr>
vnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.make_link(true)<cr>
nmap <leader>o <Plug>zettel_link_make
vmap <leader>o <Plug>zettel_link_make

let g:loaded_zettelkasten = 1
