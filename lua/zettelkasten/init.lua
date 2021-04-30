local ZK = {}

local ls = require 'zettelkasten.list'
local o = require 'zettelkasten.options'
local anchor = require 'zettelkasten.anchor'
local action = require 'zettelkasten.action'

-- Returns all zettel in path as a
-- { "anchor" = "path/to/zettel/anchor filename.md" }
-- table.
-- Recurses into subdirectories if recursive argument is true.
function ZK.get_zettel_list(path, recursive)
    return ls.get_anchors_and_paths(path, recursive or false)
end

-- Return a valid zettelkasten anchor for the current time,
-- composed of yymmddHHMM.
function ZK.get_anchor() return anchor.create() end

-- Open link under cursor, or next on line
function ZK.open_link() return action.open_selected() end

return {
    get_zettel_list = ZK.get_zettel_list,
    get_anchor = ZK.get_anchor,
    open_link = ZK.open_link
}
