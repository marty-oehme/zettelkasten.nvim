local t = require 'zettelkasten.text'

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("get_line", function()
    it("returns current line contents if no line nr passed", function()
        vim.api = {
            nvim_get_current_line = function()
                return "hello my old friend"
            end
        }
        assert.same("hello my old friend", t.get_line())
    end)
    it("returns zero-indexed line contents", function()
        vim.api = {
            nvim_buf_get_lines = function(...)
                local args = table.pack(...)
                if args[1] == 0 and args[2] + 1 == args[3] then
                    return "hello my new enemy"
                end
                return "wrong arguments"
            end
        }
        assert.same("hello my new enemy", t.get_line(1))
    end)
end)

-- describe("Zettelkasten", function()
--     it("should create an anchor for the current datetime",
--        function() assert.same(os.date('%y%m%d%H%M'), ZK.create_anchor()) end)
-- end)
