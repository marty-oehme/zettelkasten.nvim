local A = {}

local o = require 'zettelkasten.options'
local link = require 'zettelkasten.link'

local BIGNUMBER = 10000000

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

-- Returns the link currently under cursor, roughly the vim equivalent of yiW.
-- Works for links containing spaces in their text or reference link.
function A.get_link_under_cursor()
    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = link.extract_all(vim.api.nvim_get_current_line())
    for _, link in pairs(links) do
        if link.startpos <= curpos + 1 and link.endpos > curpos then
            return link
        end
    end
    return nil
end

-- Returns the next link of the current line from the cursor onwards.
function A.get_next_link_on_line()
    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = link.extract_all(vim.api.nvim_get_current_line())
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
