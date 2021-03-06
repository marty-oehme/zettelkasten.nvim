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
function ZK.link_open() return action.open_selected() end

-- Create a new link under cursor
function ZK.link_make(visual) return action.make_link(visual) end

-- If invoked in reach of a valid link will try to follow said link.
-- Otherwise will take the current context and make a link out of it.
function ZK.link_follow(visual)
    if not ZK.link_open() then ZK.link_make(visual) end
end

-- Open index file at zettel root directory. If title is passed in opens
-- `title`.<extension> file, otherwise defaults to `index`.<extension>.
function ZK.index_open(title) return action.open_index_file(title) end

return {
    get_zettel_list = ZK.get_zettel_list,
    get_anchor = ZK.get_anchor,
    link_open = ZK.link_open,
    link_make = ZK.link_make,
    link_follow = ZK.link_follow,
    index_open = ZK.index_open
}
