local A = {}

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
function A.open_selected()
    -- TODO decide between currentword/restofline option
    A.open(A.get_link_under_cursor())
end

-- Return only the link reference portion of a markdown/wiki style link
function A.extract_link(input)
    if not input then return end
    return input:match("%[%[(.+)|?.*%]%]") or input:match("%[.*%]%((.+)%)")
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

-- -- Returns the content of the line from the cursor onwards.
-- function A.get_next_link_on_line()
--     local line = vim.api.nvim_get_current_line()
--     local linenr = vim.api.nvim_win_get_cursor(0)[1]
--     print(line, linenr)
--     return ""
-- end

return {open = A.open, open_selected = A.open_selected}

-- local function get_selection()
--     s_start = vim.fn.line("'<") - 1
--     s_end = vim.fn.line("'>")
--     return vim.api.nvim_buf_get_lines(0, s_start, s_end, true)
-- end

-- -- UGLY HACKS ABOUND
-- function ZK.create_zettel()
--     -- get line and its number
--     local selection
--     local line = vim.api.nvim_get_current_line()
--     local linenr = vim.api.nvim_win_get_cursor(0)[1]

--     -- get words under cursor / selected
--     local mode = vim.api.nvim_get_mode()['mode']
--     if mode == "n" then
--         print(vim.fn.line("'<'") - 1)
--         selection = vim.fn.expand("<cWORD>")
--         -- NOT WORKING YET
--     elseif mode == "v" then
--         selection = get_selection()
--     else
--         return
--     end

--     -- get valid link
--     local link = l.create(nil, selection)

--     -- create new line with selection replaced in middle
--     local st, en = line:find(selection, 0, true)
--     local repl_line = line:sub(1, st - 1) .. link .. line:sub(en + 1)

--     -- replace existing line in favor of new one
--     vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, true, {repl_line})
-- end
