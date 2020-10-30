local L = {}

local o = require 'zettelkasten.options'
local a = require 'zettelkasten.anchor'

-- TODO split up into clean/anchor/style functions, make private
-- Returns a link to a markdown file with the anchor replaced with a zettel anchor,
-- Returns the text passed in with the anchor passed in prepended,
function L.prepend_anchor(anchor, text)
    if not text or text == "" then return anchor end

    text = anchor .. o.anchor().separator .. text
    return text
end

-- Returns the text cleaned up to be more useful in a link.
-- Spaces are replaced by dashes and everything is lowercased.
function L.clean(text)
    text = text or ""
    return text:lower():gsub(" ", "-")
end

-- Returns the untouched text with the extension set in options appended
-- at the end.
function L.append_extension(text) return text .. o.zettel().extension end

local function check_link_empty(link)
    if not link or link == "" then error("Link is not allowed to be empty.") end
end

local function trimmed(text)
    return text:match '^()%s*$' and '' or text:match '^%s*(.*%S)'
end

-- Returns a markdown-compatible transformation of the link and text combination
-- passed in.
function L.style_markdown(link, text)
    check_link_empty(link)

    return "[" .. trimmed(text) .. "](" .. link .. ")"
end

-- Returns a wikilink-compatible transformation of the link and text combination
-- passed in, adding the text as a pipe if it exists.
function L.style_wiki(link, text)
    check_link_empty(link)
    local pipe = ""
    text = trimmed(text)

    if text and text ~= "" then pipe = "|" .. text end
    return "[[" .. link .. pipe .. "]]"
end

-- Returns the correctly formatted link to a zettel with the anchor passed in.
-- Takes an optional link text which will be added to the link.
-- Takes an optional style according to which the link will be transformed.
function L.create(anchor, text, style)
    local link = L.clean(text)
    style = style or o.zettel().link_style

    if style == "markdown" then
        link = L.append_extension(L.prepend_anchor(anchor, link))
        return L.style_markdown(link, text)

    elseif style == "wiki" then
        return L.style_wiki(anchor, text)
    end
    error("Link creation failed.")
end

return L
