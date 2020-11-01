local opt = require 'zettelkasten.options'

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("zettel options", function()

    it("should return the global zettel extension if set in vim", function()
        _G.vim.g.zettel_extension = ".myextension"
        assert.same(".myextension", opt.zettel().extension)
    end)
    it("should return the buffer zettel extension if set in vim", function()
        _G.vim.b.zettel_extension = ".mybufextension"
        assert.same(".mybufextension", opt.zettel().extension)
    end)
    it("should return the default zettel extension if not set in vim",
       function() assert.same(".md", opt.zettel().extension) end)
end)

describe("zettel options", function()
    it("should return the global anchor separator if set in vim", function()
        _G.vim.g.zettel_anchor_separator = "SEPARATE"
        assert.same("SEPARATE", opt.anchor().separator)
    end)
    it("should return the buffer anchor separator if set in vim", function()
        _G.vim.b.zettel_anchor_separator = "--"
        assert.same("--", opt.anchor().separator)
    end)
    it("should return the default anchor separator if not set in vim",
       function() assert.same("_", opt.anchor().separator) end)

    it("should return the global link style if set in vim", function()
        _G.vim.g.zettel_link_style = "wiki"
        assert.same("wiki", opt.zettel().link_style)
    end)
    it("should return the buffer link style if set in vim", function()
        _G.vim.b.zettel_link_style = "wiki"
        assert.same("wiki", opt.zettel().link_style)
    end)
    it("should return the default link style if not set in vim",
       function() assert.same("markdown", opt.zettel().link_style) end)
    it("should error on entries other than markdown/wiki", function()
        _G.vim.g.zettel_link_style = "idontbelong"
        assert.is_error(function() opt.zettel() end)
    end)

    it("should return the global link following if set in vim", function()
        _G.vim.g.zettel_link_following = "line"
        assert.same("line", opt.zettel().link_following)
    end)
    it("should return the buffer link following if set in vim", function()
        _G.vim.b.zettel_link_following = "line"
        assert.same("line", opt.zettel().link_following)
    end)
    it("should return the default link following if not set in vim",
       function() assert.same("cursor", opt.zettel().link_following) end)
    it("should error on entries other than markdown/wiki", function()
        _G.vim.g.zettel_link_following = "idontbelong"
        assert.is_error(function() opt.zettel() end)
    end)
end)
