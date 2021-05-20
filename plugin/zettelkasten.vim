if exists('g:loaded_zettelkasten')
  finish
endif

noremap <Plug>zettel_link_open :lua require 'zettelkasten'.open_link()<cr>

nnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.make_link()<cr>
vnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.make_link(true)<cr>

nnoremap <Plug>zettel_link_follow :lua require 'zettelkasten'.open_or_make_link()<cr>
vnoremap <Plug>zettel_link_follow :lua require 'zettelkasten'.open_or_make_link(true)<cr>

let g:loaded_zettelkasten = 1
