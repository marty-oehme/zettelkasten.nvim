local L = {}

local o = require 'zettelkasten.options'
local a = require 'zettelkasten.anchor'

-- Returns a link to a markdown file with the date replaced with a zettel anchor,
-- and the text cleaned up to be useful in a link.
function L.create_link_text(text, date)
    text = text or ""
    if text == "" then
        text = "" .. a.create_anchor(date)
    else
        text = text:lower():gsub(" ", "-")
        text = "" .. a.create_anchor(date) .. o.anchor().separator .. text
    end
    return text .. o.zettel().extension
end

return L
