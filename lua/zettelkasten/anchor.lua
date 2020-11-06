local A = {}

local o = require 'zettelkasten.options'

-- Return a valid zettelkasten anchor,
-- composed of yymmddHHMM.
--
-- date can be passed in as a table containing a year, a month, a day, an hour,
-- and a minute key. Returns nil if the date passed in is invalid.
-- If no date is passed in, returns Zettel anchor for current moment.
function A.create(date)
    local timestamp
    if pcall(function() timestamp = os.time(date) end) then
        return os.date('%y%m%d%H%M', timestamp)
    else
        return nil
    end
end

-- TODO think about making clean/anchor/extension function module private
-- Returns the text passed in with the anchor passed in prepended.
function A.prepend(anchor, text)
    if not text or text == "" then return anchor end

    text = anchor .. o.anchor().separator .. text
    return text
end

-- Returns anchor contents if an anchor is contained in the input string.
-- It takes an optional regex parameter with which the plugin option
-- of which anchor to look for can be overwritten.
--
-- If multiple anchors are contained, returns the contents of the first
-- one encountered.
function A.extract(input, regex)
    regex = regex or o.anchor().regex
    return input:match(regex)
end

return A
