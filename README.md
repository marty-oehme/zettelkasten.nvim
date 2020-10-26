# Zettelkasten.nvim

## TODO

* [ ] go to zettel
* [ ] create new zettel
  * create link (md / wiki)
  * create anchor *
* [ ] backlinks (via rg for filename anchor?)

* \*anchor creation
  * *must* be unique
  * 10 digits, usually current date+time (YYMMDDHHmm)
  * but, if multiple links created within one minute (or other circumstances), this would duplicate
  * thus, duplicate-check before creating a new anchor
  * if duplicated, generate first *non*-duplicated link (recursive?)
