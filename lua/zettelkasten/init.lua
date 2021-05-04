local ZK = {}

local f = require 'zettelkasten.files'
local anchor = require 'zettelkasten.anchor'
local action = require 'zettelkasten.action'

-- Returns all zettel in path as a
-- { "anchor" = "path/to/zettel/anchor filename.md" }
-- table.
-- Recurses into subdirectories if recursive argument is true.
function ZK.get_zettel_list(path, recursive)
    return f.get_anchors_and_paths(f.get_all_files(path, recursive or false))
end

-- Return a valid zettelkasten anchor for the current time,
-- composed of yymmddHHMM.
function ZK.get_anchor() return anchor.create() end

-- Open link under cursor, or next on line
function ZK.open_link() return action.open_selected() end

-- Create a new link under cursor
function ZK.make_link(visual) return action.make_link(visual) end

return {
    get_zettel_list = ZK.get_zettel_list,
    get_anchor = ZK.get_anchor,
    open_link = ZK.open_link,
    make_link = ZK.make_link
}
