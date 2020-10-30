ZK = require 'zettelkasten.init'
Test_date = {year = 2019, month = 10, day = 29, hour = 16, min = 45}

describe("Zettelkasten", function()
    before_each(function() _G.vim = {g = {}, b = {}} end)
    after_each(function() _G.vim = nil end)

    describe("anchor creation", function()
        it("should return zettel anchor from time passed in", function()
            assert.same("1910291645", ZK.create_anchor(Test_date))
        end)

        it(
            "should return zettel anchor from current moment if no argument passed in",
            function()
                assert.same(os.date('%y%m%d%H%M'), ZK.create_anchor())
            end)

        it("should return nil if argument passed in is invalid", function()
            assert.is_nil(ZK.create_anchor("My grandmother is lovely."))
        end)
    end)

    describe("link creation", function()
        it(
            "should return a markdown link with only zettel anchor on no text passed in",
            function()
                assert.same("1910291645.md", ZK.create_link(nil, Test_date))
            end)

        it("should text to link", function()
            assert.same("1910291645_isappended.md",
                        ZK.create_link("isappended", Test_date))
        end)

        it("should return lowercased link text", function()
            assert.same("1910291645_yesiamshouting.md",
                        ZK.create_link("YESIAMSHOUTING", Test_date))
        end)

        it("should return spaces in text replaced with dashes", function()
            assert.same("1910291645_yes-indeed-a-space.md",
                        ZK.create_link("yes indeed a space", Test_date))
        end)

        it("should add contents of g:zettel_anchor_separator variable to link",
           function()
            vim.g.zettel_anchor_separator = "SEP"
            assert.same("1910291645SEParated.md",
                        ZK.create_link("arated", Test_date))
        end)
        it("should add contents of b:zettel_anchor_separator variable to link",
           function()
            vim.b.zettel_anchor_separator = "---"
            assert.same("1910291645---arated.md",
                        ZK.create_link("arated", Test_date))
        end)

        it("should append the filetype set in g:zettel_extension", function()
            vim.g.zettel_extension = ".something"
            assert.same("1910291645_theworld.something",
                        ZK.create_link("theworld", Test_date))
        end)
        it("should append the filetype set in b:zettel_extension", function()
            vim.b.zettel_extension = ".somethingelse"
            assert.same("1910291645_theworld.somethingelse",
                        ZK.create_link("theworld", Test_date))
        end)
    end)

end)
