local L = {}

local o = require 'zettelkasten.options'
local a = require 'zettelkasten.anchor'

-- Returns the text cleaned up to be more useful in a link.
-- Spaces are replaced by dashes and everything is lowercased.
function L.urlify(text)
    text = text or ""
    return text:lower():gsub(" ", "-")
end

-- Returns the untouched text with the extension set in options appended
-- at the end.
function L.append_extension(text) return text .. o.zettel().extension end

local function must_have(content)
    if not content or content == "" then
        error("Link is not allowed to be empty.")
    end
end

-- Returns text with surrounding whitespace trimmed. Returns empty string
-- if only whitespace.
local function trimmed(text)
    if not text then return end
    return text:match '^()%s*$' and '' or text:match '^%s*(.*%S)'
end

-- Returns a markdown-compatible transformation of the link and text combination
-- passed in.
function L.style_markdown(link, text)
    must_have(link)

    return "[" .. trimmed(text) .. "](" .. link .. ")"
end

-- Returns a wikilink-compatible transformation of the link and text combination
-- passed in, adding the text as a pipe if it exists.
function L.style_wiki(link, text)
    must_have(link)
    local pipe = ""
    text = trimmed(text)

    if text and text ~= "" then pipe = "|" .. text end
    return "[[" .. link .. pipe .. "]]"
end

-- Returns a correctly formatted link to a zettel.
-- Requires an anchor to be passed in.
-- Takes an optional link text which will be added to the link.
-- Takes an optional style according to which the link will be transformed.
function L.create(anchor, text, style)
    style = style or o.zettel().link_style

    if style == "markdown" then
        local link = (a.prepend(anchor, L.urlify(text)))
        return L.style_markdown(L.append_extension(link), text)

    elseif style == "wiki" then
        return L.style_wiki(anchor, text)
    end
    error("Link creation failed.")
end

-- Returns a correctly formatted link to a new zettel (without anchor).
-- Takes an optional link text which will be added to the link.
-- Takes an optional style according to which the link will be transformed.
function L.new(text, style)
    local anchor = a.create()
    return L.create(anchor, text, style)
end

return L
