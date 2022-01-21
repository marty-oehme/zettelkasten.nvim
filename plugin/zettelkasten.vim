if exists('g:loaded_zettelkasten')
  finish
endif

noremap <Plug>zettel_link_open :lua require 'zettelkasten'.link_open()<cr>

nnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.link_make()<cr>
vnoremap <Plug>zettel_link_make :lua require 'zettelkasten'.link_make(true)<cr>

nnoremap <Plug>zettel_link_follow :lua require 'zettelkasten'.link_follow()<cr>
vnoremap <Plug>zettel_link_follow :lua require 'zettelkasten'.link_follow(true)<cr>

nnoremap <Plug>zettel_index_open :lua require 'zettelkasten'.index_open()<cr>

let g:loaded_zettelkasten = 1
