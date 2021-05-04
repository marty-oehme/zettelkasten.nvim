local T = {}

-- Returns visually selected text and cursor column where selection starts.
-- Works with selections over multiple lines, but will only return the
-- starting line, as well as the starting line's text.
function T.get_current_selection()
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
function T.get_current_word(big)
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

-- Returns the link currently under cursor, roughly the vim equivalent of yiW.
-- Works for links containing spaces in their text or reference link.
function T.get_link_under_cursor(links, curpos)
    for _, link in pairs(links) do
        if link.startpos <= curpos + 1 and link.endpos > curpos then
            return link
        end
    end
    return nil
end

-- Returns the next link of the current line from the cursor onwards.
function T.get_next_link_on_line(links, curpos)
    local nearestpos = math.huge
    local nearestlink
    for _, link in pairs(links) do
        if link.endpos > curpos and link.endpos < nearestpos then
            nearestpos = link.endpos
            nearestlink = link
        end
    end
    return nearestlink
end

-- Sanitizes the string before replacement, taking care of escaping any
-- characters that lua uses to signify patterns.
local function replace(str, patt, repl, n)
    patt = string.gsub(patt, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    repl = string.gsub(repl, "[%%]", "%%%%")
    return string.gsub(str, patt, repl, n)
end

-- Replaces the input text on the current line with new text.
-- Takes an optional initial column on which the text to be replaced starts,
-- which can prevent falsely substituting the wrong text fragment if an
-- identical one exists earlier on the line. (E.g. I want to replace the
-- second 'test' in 'test test 1 2 3').
function T.replace_text(text, new_text, start_col)
    local line_full = vim.api.nvim_get_current_line()
    local line_edited
    if start_col then
        line_edited = line_full:sub(1, start_col - 1) ..
                          replace(line_full:sub(start_col), text, new_text, 1)
    else
        line_edited = replace(line_full, text, new_text, 1)
    end

    return line_edited
end

--- Return editor line contents.
-- Returns the content of the line number passed in or the currently active
-- line if no number passed in. Lines are, as per neovim function,
-- *zero-indexed* compared to what you see in e.g. the editor sidebar.
--- @param linenr number
--- @return string
function T.get_line(linenr)
    if linenr then return vim.api.nvim_buf_get_lines(0, linenr, linenr + 1) end
    return vim.api.nvim_get_current_line()
end

return T
