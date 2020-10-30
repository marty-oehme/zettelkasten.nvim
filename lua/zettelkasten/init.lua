local ZK = {}

local ls = require 'zettelkasten.list'
local o = require 'zettelkasten.options'
local a = require 'zettelkasten.anchor'

-- Returns all zettel in path as a
-- { "anchor" = "path/to/zettel/anchor filename.md" }
-- table.
-- Recurses into subdirectories if recursive argument is true.
function ZK.get_zettel_list(path, recursive)
    return ls.get_anchors_and_paths(path, recursive or false, ZK.options)
end


return {
    get_zettel_list = ZK.get_zettel_list
}
