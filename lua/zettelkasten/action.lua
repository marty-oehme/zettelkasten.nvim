local A = {}

local o = require 'zettelkasten.options'
local l = require 'zettelkasten.link'
local f = require 'zettelkasten.files'
local t = require 'zettelkasten.text'

-- Opens the link passed in in the editor's current buffer.
-- Requires a link object passed in.
function A.open(link)
    if not link or not link.ref then return end
    local fname = f.get_zettel_by_anchor(link.anchor) or
                      f.get_zettel_by_ref(link.ref) or link.ref
    vim.api.nvim_command(string.format("edit %s", fname))
end

-- Gets the input at the current buffer cursor and opens it
-- in the current buffer.
-- Takes an optional style of link following to use,
-- superseding the one set in options.
function A.open_selected(style)
    local st = style or o.link().following

    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = l.extract_all(vim.api.nvim_get_current_line())

    local ln
    if st == 'line' then
        ln = t.get_next_link_on_line(links, curpos)
    elseif st == 'cursor' then
        ln = t.get_link_under_cursor(links, curpos)
    end

    A.open(ln)
end

-- Replaces the current text context with a link to a new zettel.
-- The current context is the visual selection (if called from visual mode)
-- or the (big) word under the cursor if called from any other mode.
function A.link(visual)
    local selection, start_col
    if visual or vim.api.nvim_get_mode()['mode'] == "v" then
        selection, start_col = t.get_current_selection()
    else
        selection, start_col = t.get_current_word()
    end
    vim.api.nvim_set_current_line(t.replace_text(selection, l.new(selection),
                                                 start_col))
end

return {open = A.open, open_selected = A.open_selected, link = A.link}
