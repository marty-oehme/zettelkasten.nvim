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
    it("should not fail when no input is available", function()
        vim.fn = {expand = function() end}
        assert.is_not_error(action.open)
    end)
end)
describe("open_selected", function()
    it("should open the next link found if no argument passed in", function()
        vim.api = {nvim_command = mock(function() end)}
        vim.fn = {
            expand = function(sure)
                return "[" .. sure .. "](1910271456_link-to-my-file.md)"
            end
        }

        action.open_selected()
        assert.spy(vim.api.nvim_command).was_called_with(
            "edit 1910271456_link-to-my-file.md")
    end)
end)
