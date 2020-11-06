link = require 'zettelkasten.link'
Test_date = {year = 2019, month = 10, day = 29, hour = 16, min = 45}

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("urlify", function()
    it("should return lowercased link text", function()
        assert.same("yesiamshouting", link.urlify("YESIAMSHOUTING"))
    end)

    it("should return spaces in text replaced with dashes", function()
        assert.same("yes-indeed-a-space", link.urlify("yes indeed a space"))
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

describe("create", function()
    before_each(function()
        vim.g.zettel_extension = ".md"
        vim.g.zettel_anchor_separator = "_"
        vim.g.zettel_link_style = "markdown"
    end)
    after_each(function() vim.g = nil end)
    it("should create a working link using set options in vim", function()
        assert.same("[My FILE NAME](1910291645_my-file-name.md)",
                    link.create("1910291645", "My FILE NAME"))
    end)
    it("should create a working link if style is manually set", function()
        assert.same("[[1910291645|My FILE NAME]]",
                    link.create("1910291645", "My FILE NAME", "wiki"))
    end)
    it("should not error on empty text", function()
        vim.g.zettel_extension = ".wiki"
        vim.g.zettel_anchor_separator = "_"
        vim.g.zettel_link_style = "wiki"
        assert.same("[[1910291645]]", link.create("1910291645"))
    end)
    describe("wiki link styling", function()
        it("should correctly apply transformations to link and text", function()
            assert.same("[[1910291645|My AWESOME Link]]",
                        link.create("1910291645", "My AWESOME Link", "wiki"))
        end)
        it("should trim whitespace for the text area", function()
            assert.same("[[1910291645]]",
                        link.create("1910291645", "   ", "wiki"))
            assert.same("[[1910291645|hi]]",
                        link.create("1910291645", "  hi     ", "wiki"))
        end)
        describe("markdown link styling", function()
            it("should correctly apply transformations to link and text",
               function()
                assert.same("[My AWESOME Link](1910291645_my-awesome-link.md)",
                            link.create("1910291645", "My AWESOME Link",
                                        "markdown"))
            end)
            it("should trim whitespace for the text area", function()
                assert.same("[](1910291645.md)",
                            link.create("1910291645", "   ", "markdown"))
                assert.same("[hi](1910291645_hi.md)",
                            link.create("1910291645", "  hi     ", "markdown"))
            end)
        end)

    end)

end)

describe("new", function()
    it("should create a link out of only text input", function()
        local result = link.new("My FILE NAME")
        assert.is_not_nil(result:match(
                              "%[My FILE NAME%]%(.*_my%-file%-name%.md%)"))
    end)
    it("should be callable without any parameters, using default settings",
       function()
        vim.g.zettel_link_style = "wiki"
        local result = link.new()
        assert.is_not_nil(result:match("%[%[[^|]+%]%]"))
    end)
end)

describe("extract_all", function()
    it("should get all links input string", function()
        local input = "[Some text](2003042042_my-link.md) and another, [with more text](2001261123 another-link.md), and done. "
        local expected = {
            {
                endpos = 34,
                ref = "2003042042_my-link.md",
                startpos = 1,
                text = "Some text",
                anchor = "2003042042"
            }, {
                endpos = 92,
                ref = "2001261123 another-link.md",
                startpos = 49,
                text = "with more text",
                anchor = "2001261123"
            }
        }

        assert.same(expected, link.extract_all(input))
    end)
end)
