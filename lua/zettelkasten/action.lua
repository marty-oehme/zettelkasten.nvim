local A = {}

local o = require 'zettelkasten.options'

local BIGNUMBER = 10000000

local parsers = {
    markdown = {ref = "%[.-%]%((.-)%)", text = "%[(.-)%]%(.-%)"},
    wiki = {ref = "%[%[(.-)|?.-%]%]", text = "%[%[.-|?(.-)%]%]"}
}

-- Opens the link passed in in the editor's current buffer.
-- Requires a link object passed in.
function A.open(link)
    if not link or not link.ref then return end
    -- TODO follow: go to anchor, fall back to filename
    vim.api.nvim_command(string.format("edit %s", link.ref))
end

-- Gets the input at the current buffer cursor and opens it
-- in the current buffer.
-- Takes an optional style of link following to use,
-- superseding the one set in options.
function A.open_selected(style)
    local style = style or o.zettel().link_following
    if style == 'line' then
        A.open(A.get_next_link_on_line())
    elseif style == 'cursor' then
        A.open(A.get_link_under_cursor())
    end
end

-- Return all links contained in the input given in an array.
-- Returned link tables have the following structure:
-- link = { text=, ref=, startpos=27, endpos=65 }
function A.extract_all_links(input)
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
                endpos = endpos
            })
            curpos = endpos
        end
    end
    return links
end

-- Returns the link currently under cursor, roughly the vim equivalent of yiW.
-- Works for links containing spaces in their text or reference link.
function A.get_link_under_cursor()
    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = A.extract_all_links(vim.api.nvim_get_current_line())
    for _, link in pairs(links) do
        if link.startpos <= curpos + 1 and link.endpos > curpos then
            return link
        end
    end
    return nil
end

-- Returns the next link of the line from the cursor onwards.
function A.get_next_link_on_line()
    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = A.extract_all_links(vim.api.nvim_get_current_line())
    local nearestpos = BIGNUMBER
    local nearestlink
    for k, link in pairs(links) do
        if link.endpos > curpos and link.endpos < nearestpos then
            nearestpos = link.endpos
            nearestlink = link
        end
    end
    return nearestlink
end

return {open = A.open, open_selected = A.open_selected}
