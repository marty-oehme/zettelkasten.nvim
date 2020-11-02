action = require 'zettelkasten.action'

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("open", function()
    it("should open file in editor if it is a valid link", function()
        vim.api = {nvim_command = mock(function() end)}

        action.open("[some text](1910271456_link-to-my-file.md)")
        assert.spy(vim.api.nvim_command).was_called_with(
            "edit 1910271456_link-to-my-file.md")
    end)
    it("should do nothing when no link passed in", function()
        vim.fn = {expand = function() end}
        assert.is_not_error(action.open)
    end)
end)

describe("open_selected", function()
    before_each(function()
        vim.api = {
            nvim_command = mock(function() end),
            nvim_get_current_line = function(sure)
                return
                    "Hello, this is a line and [mylink](1910271456_link-to-my-file.md) whereas another [link](2030101158 another-link-now.md)"
            end,
            nvim_win_get_cursor = function(winnum) return {0, 0} end
        }
    end)
    it("should use the style passed to it, above the one set in options",
       function()
        vim.g['zettel_link_following'] = 'cursor'

        vim.api.nvim_get_current_line = mock(vim.api.nvim_get_current_line)
        action.open_selected("line")

        assert.spy(vim.api.nvim_get_current_line).was_called()
    end)
    it("should open link under cursor if option set", function()
        vim.g['zettel_link_following'] = 'cursor'
        vim.fn = {
            expand = function(sure)
                return "[" .. sure .. "](1910271456_link-to-my-file.md)"
            end
        }
        action.open_selected()
        assert.spy(vim.api.nvim_command).was_called_with(
            "edit 1910271456_link-to-my-file.md")
    end)
    it("should open next link on line if option set", function()
        vim.g['zettel_link_following'] = 'line'
        action.open_selected()
        assert.spy(vim.api.nvim_command).was_called_with(
            "edit 1910271456_link-to-my-file.md")
    end)
    it("should ignore links before cursor position", function()
        vim.g['zettel_link_following'] = 'line'
        vim.api.nvim_win_get_cursor = function(winnum) return {0, 65} end
        action.open_selected()
        assert.spy(vim.api.nvim_command).was_called_with(
            "edit 2030101158 another-link-now.md")
    end)
end)
