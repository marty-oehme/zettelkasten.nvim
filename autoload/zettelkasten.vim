echom 'this is only really necessary for vimscript plugs'
echom 'we can directly lazy-source our lua files without this redirection'

function zettelkasten#init() abort
  lua require("zettelkasten").init()
endfunction

function zettelkasten#zettel_link() abort
  lua require("zettelkasten").zettel_link()
endfunction
