# Zettelkasten.nvim

To develop / debug:

start neovim with  `nvim --cmd "set rtp+=$(pwd)" .` to automatically load the files in project dir as if they were on path

## TODO: feature wishlist

* [ ] note creation (new anchor)
  * [x] create anchor
    * [ ] *unique* anchor creation
  * [ ] create link (md / wiki)
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
 * [ ] recursive lookup for zettel
 * [ ] zettel anchor regex
* [ ] backlinks (via rg for filename anchor?)
  * [ ] keep tree of notes cached?
* [ ] completion engine (e.g. for `completion-nvim`, look in completion_buffers/completion-tags for reference)
* [ ] zettel caching for big directories
* [ ] zettel maintenance
  * [ ] fix malformed anchors
  * [ ] add missing anchors
  * [ ] 'rename' anchor (goes against stability?)
  * [ ] recognize duplicate anchors (in directory, when listing, etc)
    * [ ] provide option to rename and automatically change backlinks

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
