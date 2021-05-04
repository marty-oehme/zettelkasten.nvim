local A = {}

local f = require 'zettelkasten.files'
local l = require 'zettelkasten.link'
local o = require 'zettelkasten.options'
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
    style = style or o.link().following

    local curpos = vim.api.nvim_win_get_cursor(0)[2]
    local links = l.extract_all(t.get_line())

    local ln
    if style == 'line' then
        ln = t.get_next_link_on_line(links, curpos)
    elseif style == 'cursor' then
        ln = t.get_link_under_cursor(links, curpos)
    end

    if not ln then return false end

    A.open(ln)
    return true
end

-- Replaces the current text context with a link to a new zettel.
-- The current context is the visual selection (if called from visual mode)
-- or the (big) word under the cursor if called from any other mode.
function A.make_link(visual)
    local selection, start_col
    if visual then
        selection, start_col = t.get_current_selection()
    else
        selection, start_col = t.get_current_word()
    end
    vim.api.nvim_set_current_line(t.replace_text_in_current_line(selection,
                                                                 l.new(selection),
                                                                 start_col))
end

return {open = A.open, open_selected = A.open_selected, make_link = A.make_link}
