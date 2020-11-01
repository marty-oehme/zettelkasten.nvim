# Zettelkasten.nvim

To develop / debug:

start neovim with  `nvim --cmd "set rtp+=$(pwd)" .` to automatically load the files in project dir as if they were on path

next up:
* link following option (under cursor, next on line)
* next link on line function (actions)
* helper function to decide which one to use from A.open

## TODO: needed functionality

* [ ] note creation (new anchor)
  * [x] create anchor
    * [ ] *unique* anchor creation
  * [x] create link (md / wiki)
* [ ] note listing (anchors / titles, no anchor)
  * [ ] list anchors
  * [ ] list filenames
* [ ] link following (to existing anchor)
* [ ] link creation (to existing note)
  * [ ] list existing
  * [ ] create link (md / wiki)
* [ ] link switching (to another existing note)
* [ ] note search (title / full-text)
* [ ] jump to zettel (open existing anchor)
  * [ ] select by anchor
  * [ ] select by (fuzzy) title match
* [ ] options
 * [x] zettel anchor separator
 * [x] zettel extension
 * [x] link style (wiki/markdown)
  * [ ] custom link style?
 * [ ] link detection/following (under word, next on line)
 * [ ] recursive dir lookup for zettel
 * [ ] zettel anchor regex

## TODO: nice-to-haves

* [ ] refactor parsers (md/wiki) to be tables of functions/regex in options, so e.g. valid link detection can call `options.parser.isValidLink(link)` or transformation `options.parser.styleLink(anchor, text)`
* [ ] completion engine (e.g. for `completion-nvim`, look in completion_buffers/completion-tags for reference)
* [ ] zettel caching for big directories
* [ ] backlinks (via rg for filename anchor?)
  * [ ] keep tree of notes cached?
* [ ] zettel maintenance
  * [ ] fix malformed anchors
  * [ ] add missing anchors
  * [ ] 'rename' anchor (goes against stability?)
  * [ ] recognize duplicate anchors (in directory, when listing, etc)
    * [ ] provide option to rename and automatically change backlinks
* [ ] zettel 'lens' (preview first headline + content of linked zettel through floating window etc, on keypress)

* anchor creation
  * *must* be unique
  * default: 10 digits, usually current date+time (YYMMDDHHmm)
  * but, if multiple links created within one minute (or other circumstances), this would duplicate
  * thus, duplicate-check before creating a new anchor
  * if duplicated, generate first *non*-duplicated link (recursive?)
  * try to move *backwards* through minutes not forward
    * i.e. if 2030101200 exists move to 2030101159, 2030101158, ...
    * if moving backwards, we do not take away id space from *future* note creation
    * if moving forwards, every zettel created within a minute would delay next zettel creation *another* minute

## Options

atm:
```
anchor_separator = vim.g["zettel_anchor_separator"] or vim.b["zettel_anchor_separator"] or "_",
zettel_extension = vim.g["zettel_extension"] or vim.b["zettel_extension"] or ".md",
zettel_root = vim.g["zettel_root"] or vim.b["zettel_root"] or "~/documents/notes",
```
