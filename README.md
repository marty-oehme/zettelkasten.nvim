# Zettelkasten.nvim

To develop / debug:

start neovim with  `nvim --cmd "set rtp+=$(pwd)" .` to automatically load the files in project dir as if they were on path

## TODO: needed functionality

* [ ] note creation (new anchor)
  * [x] create anchor
    * [ ] *unique* anchor creation
    * [ ] implement custom anchor creation function to go with custom anchor regex
  * [x] create link (md / wiki)
* [ ] note listing (anchors / titles, no anchor)
  * [ ] list anchors
  * [ ] list filenames
* [x] link following (to existing anchor)
  * [x] fallback to filename if anchor invalid / not found
* [ ] link creation (to existing note)
  * [ ] list existing
  * [ ] create link (md / wiki)
* [ ] link switching (point to another existing note)
* [ ] note search (title / full-text)
* [x] jump to zettel (open existing anchor)
  * [x] select by anchor
  * [x] select by link/title match
  * [ ] Opt: select by fuzzy title match
* [ ] options
 * [x] zettel anchor separator
 * [x] zettel extension
 * [x] link style (wiki/markdown)
  * [ ] custom link style?
 * [x] link detection/following (under word, next on line)
 * [ ] recursive dir lookup for zettel
 * [ ] zettel anchor regex

## TODO: maintenance

* [ ] remove hard-coding of option vimnames in tests, now that we can dynamically change this through a single table

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

## Options

Options can currently be set via lua:

```lua
vim.g["zettel_extension"] = ".wiki"
```

or via vimscript:

```vim
let g:zettel_extension = ".wiki"
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
