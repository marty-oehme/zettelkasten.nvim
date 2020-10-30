local ZK = {}

local ls = require 'zettelkasten.list'
local o = require 'zettelkasten.options'

-- entrypoint for pressing the zettel key when the cursor
-- is either on an existing link  (it will then
-- follow it) or over text (it will then turn it into a
-- zettel link)
function ZK.follow_link()
    assert(false, "NOT IMPLEMENTED")
    return ''
end

-- Return a valid zettelkasten anchor,
-- composed of yymmddHHMM.
--
-- date can be passed in as a table containing a year, a month, a day, an hour,
-- and a minute key. Returns nil if the date passed in is invalid.
-- If no date is passed in, returns Zettel anchor for current moment.
function ZK.create_anchor(date)
    local timestamp
    if pcall(function() timestamp = os.time(date) end) then
        return os.date('%y%m%d%H%M', timestamp)
    else
        return nil
    end
end

-- Returns a link to a markdown file with the date replaced with a zettel anchor,
-- and the text cleaned up to be useful in a link.
function ZK.create_link(text, date)
    text = text or ""
    if text == "" then
        text = "" .. ZK.create_anchor(date)
    else
        text = text:lower():gsub(" ", "-")
        text = "" .. ZK.create_anchor(date) .. o.anchor().separator .. text
    end
    return text .. o.zettel().extension
end

-- Returns all zettel in path as a
-- { "anchor" = "path/to/zettel/anchor filename.md" }
-- table.
-- Recurses into subdirectories if recursive argument is true.
function ZK.get_zettel_list(path, recursive)
    return ls.get_anchors_and_paths(path, recursive or false, ZK.options)
end

return {
    zettel_link_create = ZK.zettel_link_create,
    create_anchor = ZK.create_anchor,
    create_link = ZK.create_link,
    get_zettel_list = ZK.get_zettel_list
}
