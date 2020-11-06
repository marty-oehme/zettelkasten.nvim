local L = {}

local o = require 'zettelkasten.options'
local a = require 'zettelkasten.anchor'

local parsers = {
    markdown = {
        ref = "%[.-%]%((.-)%)",
        text = "%[(.-)%]%(.-%)",
        style_func = function(anchor, text, extension)
            local link = (a.prepend(anchor, L.urlify(L.trimmed(text))))
            return "[" .. L.trimmed(text) .. "](" .. link .. extension .. ")"
        end
    },
    wiki = {
        ref = "%[%[(.-)|?.-%]%]",
        text = "%[%[.-|?(.-)%]%]",
        style_func = function(anchor, text)
            local pipetxt = ""
            text = L.trimmed(text)

            if text and text ~= "" then pipetxt = "|" .. text end
            return "[[" .. anchor .. pipetxt .. "]]"
        end
    }
}

-- Returns the text cleaned up to be more useful in a link.
-- Spaces are replaced by dashes and everything is lowercased.
function L.urlify(text)
    text = text or ""
    return text:lower():gsub(" ", "-")
end

-- Returns the untouched text with the extension set in options appended
-- at the end.
function L.append_extension(text) return text .. o.zettel().extension end

-- Returns text with surrounding whitespace trimmed. Returns empty string
-- if only whitespace.
function L.trimmed(text)
    if not text then return end
    return text:match '^()%s*$' and '' or text:match '^%s*(.*%S)'
end

-- Returns a correctly formatted link to a zettel.
-- Requires an anchor to be passed in.
-- Takes an optional link text which will be added to the link.
-- Takes an optional style according to which the link will be transformed.
function L.create(anchor, text, style)
    style = style or o.link().style

    return parsers[style].style_func(anchor, text, o.zettel().extension)
end

-- Returns a correctly formatted link to a new zettel (without anchor).
-- Takes an optional link text which will be added to the link.
-- Takes an optional style according to which the link will be transformed.
function L.new(text, style)
    local anchor = a.create()
    return L.create(anchor, text, style)
end

-- Return all links contained in the input given in an array.
-- Returned link tables have the following structure:
-- link = { text=, ref=, startpos=27, endpos=65 }
function L.extract_all(input)
    if not input then return end
    local links = {}
    local curpos = 1
    for _, parser in pairs(parsers) do
        while input:find(parser.ref, curpos) do
            local ref = input:match(parser.ref, curpos)
            local text = input:match(parser.text, curpos)
            local startpos, endpos = input:find(parser.ref, curpos)
            table.insert(links, {
                ref = ref,
                text = text,
                startpos = startpos,
                endpos = endpos,
                anchor = a.extract(ref)
            })
            curpos = endpos
        end
    end
    return links
end

return {
    new = L.new,
    create = L.create,
    append_extension = L.append_extension,
    urlify = L.urlify,
    extract_all = L.extract_all
}
