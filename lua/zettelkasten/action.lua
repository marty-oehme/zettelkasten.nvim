local A = {}

local o = require 'zettelkasten.options'

local parsers = {markdown = "%[.-%]%((.-)%)", wiki = "%[%[(.+)|?.-%]%]"}

-- Extracts a file name from a link and opens the corresponding file
-- in the current buffer.
-- Takes an optional input parameter
function A.open(input)
    local fname = A.extract_link(input)
    if not fname then return end
    -- TODO follow: go to anchor, fall back to filename
    vim.api.nvim_command(string.format("edit %s", fname))
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

-- Return only the link reference portion of a markdown/wiki style link.
-- For example, for a markdown link [my text](my-link.md)
-- it would only return my-link.md
function A.extract_link(input)
    if not input then return end
    for _, parser in pairs(parsers) do return input:match(parser) end
    return
end

-- Returns the word currently under cursor, the vim equivalent of yiW.
-- Takes an optional boolean flag to set the word being caught
-- to the vim equivalent of doing yiw, a more exclusive version.
function A.get_link_under_cursor(small)
    local c = "<cWORD>"
    if small then c = "<cword>" end
    local word = vim.fn.expand(c)
    return word
end

-- Returns the content of the line from the cursor onwards.
function A.get_next_link_on_line()
    local line = vim.api.nvim_get_current_line()
    return line:sub(vim.api.nvim_win_get_cursor(0)[2])
end

return {open = A.open, open_selected = A.open_selected}
