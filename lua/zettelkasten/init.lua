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

-- Return a valid zettelkasten anchor for the current time,
-- composed of yymmddHHMM.
function ZK.create_anchor() return a.create() end

return {get_zettel_list = ZK.get_zettel_list, create_anchor = ZK.create_anchor}
