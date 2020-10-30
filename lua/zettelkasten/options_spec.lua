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
end)
