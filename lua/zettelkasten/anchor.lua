local A = {}

local o = require 'zettelkasten.options'

local function deduplicate(anchor, anchorfct)
    while A.is_duplicate(anchor, anchorfct) do anchor = anchor - 1 end
    return anchor
end

-- Return a valid zettelkasten anchor,
-- composed of yymmddHHMM.
--
-- date can be passed in as a table containing a year, a month, a day, an hour,
-- and a minute key. Returns nil if the date passed in is invalid.
-- If no date is passed in, returns Zettel anchor for current moment.
function A.create(date, anchorfct)
    local timestamp
    if pcall(function() timestamp = os.time(date) end) then
        local anchor = os.date('%y%m%d%H%M', timestamp)
        if anchorfct then anchor = deduplicate(anchor, anchorfct) end
        return tostring(anchor)
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

-- Returns a set of all anchors created by the function passed in
-- (if argument is set) or all anchors currently in zettel root dir
-- (if no argument passed).
function A.list(anchor_function)
    if not anchor_function then return {} end
    return anchor_function()
end

-- Returns true if anchor passed in already exists, false otherwise.
-- Takes an optional set of anchors to compare against, will
-- compare against all anchors in zettel root dir otherwise.
function A.is_duplicate(anchor, anchor_function)
    local all_anchors = A.list(anchor_function)
    if all_anchors[anchor] ~= nil then return true end
    return false
end

return A
