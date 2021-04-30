local A = {}

local o = require 'zettelkasten.options'
local link = require 'zettelkasten.link'
local list = require 'zettelkasten.files'

local BIGNUMBER = 10000000

-- Opens the link passed in in the editor's current buffer.
-- Requires a link object passed in.
function A.open(zlink)
    if not zlink or not zlink.ref then return end
    local fname = list.get_zettel_by_anchor(zlink.anchor) or zlink.ref
    vim.api.nvim_command(string.format("edit %s", fname))
end

-- Gets the input at the current buffer cursor and opens it
-- in the current buffer.
-- Takes an optional style of link following to use,
-- superseding the one set in options.
function A.open_selected(style)
    local st = style or o.link().following

    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = link.extract_all(vim.api.nvim_get_current_line())

    if st == 'line' then
        A.open(A.get_next_link_on_line(links, curpos))
    elseif st == 'cursor' then
        A.open(A.get_link_under_cursor(links, curpos))
    end
end

-- Returns the link currently under cursor, roughly the vim equivalent of yiW.
-- Works for links containing spaces in their text or reference link.
function A.get_link_under_cursor(links, curpos)
    for _, l in pairs(links) do
        if l.startpos <= curpos + 1 and l.endpos > curpos then return l end
    end
    return nil
end

-- Returns the next link of the current line from the cursor onwards.
function A.get_next_link_on_line(links, curpos)
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

--- local function get_selection()
---     s_start = vim.fn.line("'<") - 1
---     s_end = vim.fn.line("'>")
---     return vim.api.nvim_buf_get_lines(0, s_start, s_end, true)
--- end
--
--- -- UGLY HACKS ABOUND
--- function ZK.create_zettel()
---     -- get line and its number
---     local selection
---     local line = vim.api.nvim_get_current_line()
---     local linenr = vim.api.nvim_win_get_cursor(0)[1]
--
---     -- get words under cursor / selected
---     local mode = vim.api.nvim_get_mode()['mode']
---     if mode == "n" then
---         print(vim.fn.line("'<'") - 1)
---         selection = vim.fn.expand("<cWORD>")
---         -- NOT WORKING YET
---     elseif mode == "v" then
---         selection = get_selection()
---     else
---         return
---     end
--
---     -- get valid link
---     local link = l.create(nil, selection)
--
---     -- create new line with selection replaced in middle
---     local st, en = line:find(selection, 0, true)
---     local repl_line = line:sub(1, st - 1) .. link .. line:sub(en + 1)
--
---     -- replace existing line in favor of new one
---     vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, true, {repl_line})
--- end
