# Zettelkasten.nvim

A simple Zettelkasten plugin.

Currently allows note link creation
(automatically appending a time-based anchor to each created note)
in markdown and wiki-link style, as well as following links to other notes,
wherever they are in the notes directory.

Not much more has been implemented yet,
but some options can already be configured by the user.

Lastly, this plugin is in *very* rough shape,
so don't expect too much as of now.
It works what I desperately needed it to work for
and thus the additional functionalities will only come trickling in,
but there's not much here yet.

## Usage

The one mapping you probably want to undertake (replacing the mapping as needed) is:

### Linking

```vim
nnoremap <cr> :lua require 'zettelkasten'.open_or_make_link()<cr>
vnoremap <cr> :lua require 'zettelkasten'.open_or_make_link(true)<cr>
```

This will allow you to create new links when over any text,
or having text selected;
as well as follow links to existing or new notes.
It will look through your notes in the zettel directory you set
(look for the options below).
If you pass in `true` it will work for visual mode instead of normal mode instead.

The function is also exposed as vim mapping `<Plug>zettel_link_follow`, so can be 
set via `map <cr> <Plug>zettel_link_follow` to get the same result as above.

```vim
:lua require 'zettelkasten'.open_link()
:lua require 'zettelkasten'.make_link(visualmode)
```

allows you to separate the link following and creation set by one function above.
Again, you can pass in `true` for link creation to make it work 
correctly from visual mode.

The functions are again exposed as `<Plug>zettel_link_open` and
`<Plug>zettel_link_make` respectively.


```vim
```


### Listing

You can have a valid zettel anchor returned by using the 
`:lua require 'zettelkasten'.get_anchor()` function.

The only other exposed function currently is:

`:lua require 'zettelkasten'.get_zettel_list(path, recursive)`

to list all existing zettel in a directory.
The path in this instance is required.
Recursive is an optional boolean variable telling the function if it should 
recourse into subdirectories on the hunt for zettel and return those as well.


## Options

Options can currently be set via lua:

```lua
vim.g["zettel_extension"] = ".md"
vim.g["zettel_root"] = "~/documents/notes"
```

or via vimscript:

```vim
let g:zettel_extension = ".wiki"
let g:zettel_root = "~/documents/notes"
```

The functionality is the same. The plugin will look up options by precedence buffer > global > default.

```lua
anchor_separator = vim.b["zettel_anchor_separator"] or vim.g["zettel_anchor_separator"] or "_",
zettel_extension = vim.b["zettel_extension"] or vim.g["zettel_extension"] or ".md",
zettel_root = vim.b["zettel_root"] or vim.g["zettel_root"] or "~/documents/notes",
```

Since, as long as the api still changes rapidly,
a list of options would quickly be outdated,
what you can instead is to look into `options.lua`,
where at the top the currently effective options with their defaults and available values are defined.

## up next

* note listing
* note jumping (existing to existing)

## TODO: needed functionality

* [ ] note creation (new anchor)
  * [x] create anchor
    * [x] *unique* anchor creation checking existing zettels
    * [ ] unique anchor creation for multiple quick-repetition link creation (see [#anchor creation] section)
    * [ ] implement custom anchor creation function to go with custom anchor regex (turn anchor options into objects similar to parsers, to let *them* do the work)
  * [x] create link (md / wiki)
* [ ] note listing (anchors / titles, no anchor)
  * [ ] list anchors
  * [ ] list filenames
* [x] link following (to existing anchor)
  * [x] fallback to filename if anchor invalid / not found
  * [x] maintain location list of previous jumps
* [ ] link creation (to existing note)
  * [ ] list existing
  * [ ] create link (md / wiki)
* [x] allow same command for following/creating link depending on cursor over link or not
* [ ] link switching (point to another existing note)
* [ ] note search (title / full-text)
* [ ] jump to zettel (open existing anchor)
  * [ ] select by anchor
  * [ ] select by link/title match
  * [ ] Opt: select by fuzzy title match
* [ ] options
 * [x] zettel anchor separator
 * [x] zettel extension
 * [x] link style (wiki/markdown)
  * [ ] custom link style?
 * [x] link detection/following (under word, next on line)
 * [ ] recursive dir lookup for zettel
 * [x] zettel anchor regex
 * [ ] open zettel root directory / index page
    * [x] index.md at root directory
    * [x] custom index page name option

## TODO: maintenance

* [ ] remove hard-coding of option vimnames in tests, now that we can dynamically change this through a single table
* [ ] change options handling, so there's no function having to be invoked every time (`o.zettel().extension`..) (e.g. through initial setup function)

## Anchor Creation

* *must* be unique
* default: 10 digits, usually current date+time (YYMMDDHHmm)
* but, if multiple links created within one minute (or other circumstances), this would duplicate
* thus, duplicate-check before creating a new anchor
  * go through all existing zettels and check id
  * but also, what if generating multiple new zettels quickly after another? (e.g. vim macro)
      * then new zettel do not exist as a file yet, thus can not be checked for
      * possibly unique anchor function should check both files and existing anchor id's in currently open zettel (e.g. in links)
          * can not possibly check in all other zettels, and should rarely be necessary for zettel creation
      * then, merge the two existing lists and check for uniqueness in merged list?
* if duplicated, generate first *non*-duplicated link (recursive?)
  * try to move *backwards* through minutes not forward
    * i.e. if 2030101200 exists move to 2030101159, 2030101158, ...
  * if moving backwards, we do not take away id space from *future* note creation
    * if moving forwards, every zettel created within a minute would delay next zettel creation *another* minute

* to decide: should zettel creation create a zettel in current working dir or at zettel root dir? or set by option?

* [ ] (CODE) switch -- comments to --- doc comments for function descriptions etc

## TODO: nice-to-haves

* [ ] refactor parsers (md/wiki) to be tables of functions/regex in options, so e.g. valid link detection can call `options.parser.isValidLink(link)` or transformation `options.parser.styleLink(anchor, text)`
  * [ ] use unified parser model (e.g. containing `turn-to-link()`, `parse-link()`) function
  * [ ] enable custom parser supply
* [ ] completion engine (e.g. for `completion-nvim`, look in completion_buffers/completion-tags for reference)
* [ ] zettel caching for big directories
* [ ] backlinks (via rg for filename anchor?)
  * [ ] keep tree of notes cached?
* [ ] zettel maintenance
  * [ ] fix malformed anchors
    * [ ] fix-link function which looks for most similar file to be found and renames file/link automatically (after confirmation)
  * [ ] add missing anchors
  * [ ] 'rename' anchor (goes against stability?)
  * [ ] recognize duplicate anchors (in directory, when listing, etc)
    * [ ] potentially warn user
    * [ ] provide option to rename and automatically change backlinks
* [ ] zettel 'lens' (preview first headline + content of linked zettel through floating window etc, on keypress)
* [ ] support *both* md-style and wiki-style links at the same time
* [ ] file/directory exception list for gathering files, which will be ignored
* [ ] 'strict' mode *only* matching and following valid anchor links
* [ ] link creation - remove special marks, make customizable (e.g. i- will: help. -> i--will:-help..md [currently] -> i-will-help.md [possibly])
* [ ] option to automatically save on switching zettel, making link jumping/ zettel creation easier
* [ ] function exposed to jump cursor to next/previous link
* [ ] index file functionality
    * [ ] several default options (index, home, wiki, ..)
    * [ ] optionally look for index file in sub-directories (could allow 'zettel' being directories as well)
    * [ ] if not existing could be auto-populated by adjacent zettel links (e.g. in same directory; backlinked; ..)

## Developing / Debugging

start neovim with  `nvim --cmd "set rtp+=$(pwd)" .` to automatically load the files in project dir as if they were on path.

Put the following function in the plugin directory as `debug.vim` or similar and you can instantly reload the plugin during development.

```lua
" TODO for DEBUGGING ONLY: reloads the whole lua plugin
fun! ZKReload()
  lua for k in pairs(package.loaded) do if k:match("^zettelkasten")  then package.loaded[k] = nil end end
  lua require 'zettelkasten'
endfun
nnoremap <leader>R :call ZKReload()<cr>
```
