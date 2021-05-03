local A = {}

local o = require 'zettelkasten.options'
local l = require 'zettelkasten.link'
local f = require 'zettelkasten.files'

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
        ln = A.get_next_link_on_line(links, curpos)
    elseif st == 'cursor' then
        ln = A.get_link_under_cursor(links, curpos)
    end

    A.open(ln)
end

-- Returns visually selected text and cursor column where selection starts.
-- Works with selections over multiple lines, but will only return the
-- starting line, as well as the starting line's text.
local function get_current_selection()
    local line, start_col, end_col = vim.fn.getpos("'<")[2],
                                     vim.fn.getpos("'<")[3],
                                     vim.fn.getpos("'>")[3]
    local selection = vim.fn.getline(line, line)[1]:sub(start_col, end_col)
    return selection, start_col
end

-- Returns word currently under cursor and cursor column where
-- the word begins.
-- If big argument resolves to true, it will get the whitespace
-- delimited word, otherwise the vim specified wordboundary word.
local function get_current_word(big)
    local pattern = [[\k]]
    if not big then pattern = [[\S]] end

    local cur_col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    local word_before_cur = vim.fn.matchstrpos(line:sub(1, cur_col + 1),
                                               pattern .. "*$")
    local word_start_col = word_before_cur[2] + 1
    word_before_cur = word_before_cur[1]

    local word_after_cur = vim.fn.matchstr(line:sub(cur_col + 1),
                                           "^" .. pattern .. "*"):sub(2)

    return word_before_cur .. word_after_cur, word_start_col
end

-- Sanitizes the string before replacement, taking care of escaping any
-- characters that lua uses to signify patterns.
local function replace(str, patt, repl, n)
    patt = string.gsub(patt, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    repl = string.gsub(repl, "[%%]", "%%%%")
    return string.gsub(str, patt, repl, n)
end

-- Replaces the input text on the current line with a zettel link.
-- Takes an optional initial column on which the text to be replaced starts,
-- which can prevent falsely substituting the wrong text fragment if an
-- identical one exists earlier on the line.
local function replace_text_with_link(text, start_col)
    local link = l.new(text)

    local line_full = vim.api.nvim_get_current_line()
    local line_edited
    if start_col then
        line_edited = line_full:sub(1, start_col - 1) ..
                          replace(line_full:sub(start_col), text, link, 1)
    else
        line_edited = replace(line_full, text, link, 1)
    end

    return line_edited
end

-- Replaces the current text context with a link to a new zettel.
-- The current context is the visual selection (if called from visual mode)
-- or the (big) word under the cursor if called from any other mode.
function A.link(visual)
    local selection, start_col
    if visual or vim.api.nvim_get_mode()['mode'] == "v" then
        selection, start_col = get_current_selection()
    else
        selection, start_col = get_current_word()
    end
    vim.api.nvim_set_current_line(replace_text_with_link(selection, start_col))
end

-- Returns the link currently under cursor, roughly the vim equivalent of yiW.
-- Works for links containing spaces in their text or reference link.
function A.get_link_under_cursor(links, curpos)
    for _, link in pairs(links) do
        if link.startpos <= curpos + 1 and link.endpos > curpos then
            return link
        end
    end
    return nil
end

-- Returns the next link of the current line from the cursor onwards.
function A.get_next_link_on_line(links, curpos)
    local nearestpos = math.huge
    local nearestlink
    for _, ln in pairs(links) do
        if ln.endpos > curpos and ln.endpos < nearestpos then
            nearestpos = ln.endpos
            nearestlink = ln
        end
    end
    return nearestlink
end

return {open = A.open, open_selected = A.open_selected, link = A.link}

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
