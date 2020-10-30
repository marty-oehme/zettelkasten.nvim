link = require 'zettelkasten.link'
Test_date = {year = 2019, month = 10, day = 29, hour = 16, min = 45}

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("prepend_anchor", function()
    it("should append text to link", function()
        assert.same("1910291645_isappended",
                    link.prepend_anchor("1910291645", "isappended"))
    end)
    it("should not add a separator if no text appended", function()
        assert.same("1910291645", link.prepend_anchor("1910291645", ""))
    end)

    it("should return solely the anchor if no text is passed in", function()
        assert.same("1910291645", link.prepend_anchor("1910291645", nil))
    end)
    it("should return solely the anchor if empty text is passed in", function()
        assert.same("1910291645", link.prepend_anchor("1910291645", ""))
    end)
    it("should add contents of g:zettel_anchor_separator variable to link",
       function()
        vim.g.zettel_anchor_separator = "SEP"
        assert.same("1910291645SEParated",
                    link.prepend_anchor("1910291645", "arated"))
    end)
    it("should add contents of b:zettel_anchor_separator variable to link",
       function()
        vim.b.zettel_anchor_separator = "---"
        assert.same("1910291645---arated",
                    link.prepend_anchor("1910291645", "arated"))
    end)
end)

describe("clean", function()
    it("should return lowercased link text", function()
        assert.same("yesiamshouting", link.clean("YESIAMSHOUTING"))
    end)

    it("should return spaces in text replaced with dashes", function()
        assert.same("yes-indeed-a-space", link.clean("yes indeed a space"))
    end)
end)

describe("append_extension", function()
    it("should append the contents set in global zettel extension option",
       function()
        vim.g.zettel_extension = ".extension"
        assert.same("myfile.extension", link.append_extension("myfile"))
    end)
    it("should append the contents set in global zettel extension option",
       function()
        vim.b.zettel_extension = ".bufext"
        assert.same("myfile.bufext", link.append_extension("myfile"))
    end)
end)

describe("style_markdown", function()
    it("should correctly apply transformations to link and text", function()
        assert.same("[My AWESOME Link](1910291645_my-awesome-link.md)",
                    link.style_markdown("1910291645_my-awesome-link.md",
                                        "My AWESOME Link"))
    end)
    it("should trim whitespace for the text area", function()
        assert.same("[](1910291645_my-awesome-link.md)",
                    link.style_markdown("1910291645_my-awesome-link.md", "   "))
        assert.same("[hi](1910291645_my-awesome-link.md)", link.style_markdown(
                        "1910291645_my-awesome-link.md", "  hi     "))
    end)
    it("should error if no link provided", function()
        assert.is_error(function() link.style_markdown("", "mytext") end)
        assert.is_error(function() link.style_markdown(nil, "mytext") end)
    end)
end)

describe("style_wiki", function()
    it("should error if no link provided", function()
        assert.is_error(function() link.style_wiki("", "mytext") end)
        assert.is_error(function() link.style_wiki(nil, "mytext") end)
    end)
    it("should correctly apply transformations to link and text", function()
        assert.same("[[1910291645|My AWESOME Link]]",
                    link.style_wiki("1910291645", "My AWESOME Link"))
    end)
    it("should trim whitespace for the text area", function()
        assert.same("[[1910291645]]", link.style_wiki("1910291645", "   "))
        assert.same("[[1910291645|hi]]",
                    link.style_wiki("1910291645", "  hi     "))
    end)
end)

describe("create_link", function()
    it("should create a working link using set options in vim", function()
        vim.g.zettel_extension = ".md"
        vim.g.zettel_anchor_separator = "_"
        vim.g.zettel_link_style = "markdown"
        assert.same("[My FILE NAME](1910291645_my-file-name.md)",
                    link.create("1910291645", "My FILE NAME"))
    end)
    it("should create a working link if style is manually set", function()
        vim.g.zettel_extension = ".md"
        vim.g.zettel_anchor_separator = "_"
        vim.g.zettel_link_style = "markdown"
        assert.same("[[1910291645|My FILE NAME]]",
                    link.create("1910291645", "My FILE NAME", "wiki"))
    end)
end)
