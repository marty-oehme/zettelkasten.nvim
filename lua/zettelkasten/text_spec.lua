local t = require 'zettelkasten.text'

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("get_current_selection", function()
    before_each(function()
        vim.fn = {
            getpos = function(mark)
                if mark == "'<" then
                    return {0, 1, 15}
                elseif mark == "'>" then
                    return {0, 1, 23}
                end
            end
        }
        vim.api = {
            nvim_buf_get_lines = function()
                return {"unfortunately we did it not"}
            end
        }
    end)
    it("returns the selected area",
       function() assert.same("we did it", t.get_current_selection()) end)
    it("returns the starting selection column", function()
        local _, result = t.get_current_selection()
        assert.same(15, result)
    end)
end)

describe("get_current_word", function()
    it("returns the complete word the cursor is over", function()
        vim.api = {
            nvim_get_current_line = function()
                return "we found aWord here"
            end,
            nvim_win_get_cursor = function() return {0, 12, 0} end
        }
        vim.fn = {
            matchstrpos = function(txt, _)
                if #txt == 13 then return {"aWor", 1} end
            end,
            matchstr = function(_, _) return "rd" end
        }
        assert.same("aWord", t.get_current_word())
    end)
end)

describe("replace_text", function()
    before_each(function()
        vim.api = {
            nvim_get_current_line = function()
                return "we-are? pretty pretty"
            end
        }
    end)

    it("returns the current editor line with input text correctly replaced",
       function()
        assert.same("you-are? pretty pretty",
                    t.replace_text_in_current_line("we", "you"))
    end)

    it("only replaces exactly one instance of whatever it matches", function()
        assert.same("we-are? awesome pretty",
                    t.replace_text_in_current_line("pretty", "awesome"))
    end)

    it("avoids replacing the first line match if the second should be replaced",
       function()
        assert.same("we-are? pretty awesome",
                    t.replace_text_in_current_line("pretty", "awesome", 15))
    end)

    it("correctly replaces dashes, or other lua special matching characters",
       function()
        assert.same("we-are! amazingly? pretty pretty",
                    t.replace_text_in_current_line("we-are", "we-are! amazingly"))
    end)

end)

describe("get_line", function()
    before_each(function()
        vim.api = {
            nvim_get_current_line = function()
                return "hello my old friend"
            end,
            nvim_buf_get_lines = function(...)
                local args = table.pack(...)
                if args[1] == 0 and args[2] + 1 == args[3] then
                    return {"hello my new enemy"}
                end
                return {"wrong arguments"}
            end
        }
    end)
    it("returns current line contents if no line nr passed",
       function() assert.same("hello my old friend", t.get_line()) end)
    it("returns arbitrary line contents when numbered",
       function() assert.same("hello my new enemy", t.get_line(1)) end)
    it("takes a 1-indexed line but calls the nvim internal 0-index", function()
        local gl = mock(vim.api)
        t.get_line(1)
        assert.spy(gl.nvim_buf_get_lines).was_called_with(0, 0, 1, false)
        mock.revert(t)
    end)
end)
