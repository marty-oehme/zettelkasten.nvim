local A = require 'zettelkasten.anchor'
Test_date = {year = 2019, month = 10, day = 29, hour = 16, min = 45}

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("create", function()
    it("should return zettel anchor from time passed in",
       function() assert.same("1910291645", A.create(Test_date)) end)

    it(
        "should return zettel anchor from current moment if no argument passed in",
        function() assert.same(os.date('%y%m%d%H%M'), A.create()) end)

    it("should return nil if argument passed in is invalid",
       function() assert.is_nil(A.create("My grandmother is lovely.")) end)

    it(
        "should lower timestamps until the first non-duplicated one if valid anchor gathering function passed",
        function()
            Anchor_fct = function()
                return {
                    ["2010261208"] = "/path/to/my/anchor.md",
                    ["1910291645"] = "/path/to/my/other_anchor.md"
                }
            end
            assert.same("1910291644", A.create(Test_date, Anchor_fct))
        end)

    it(
        "should ignore duplicate timestamps if no anchor gathering function passed",
        function() assert.same("1910291645", A.create(Test_date)) end)
end)

describe("prepend", function()
    it("should append text to anchor", function()
        assert.same("1910291645_isappended",
                    A.prepend("1910291645", "isappended"))
    end)
    it("should not add a separator if no text appended",
       function() assert.same("1910291645", A.prepend("1910291645", "")) end)

    it("should return solely the anchor if no text is passed in",
       function() assert.same("1910291645", A.prepend("1910291645", nil)) end)
    it("should return solely the anchor if empty text is passed in",
       function() assert.same("1910291645", A.prepend("1910291645", "")) end)
    it("should add contents of g:zettel_anchor_separator variable to text",
       function()
        vim.g.zettel_anchor_separator = "SEP"
        assert.same("1910291645SEParated", A.prepend("1910291645", "arated"))
    end)
    it("should add contents of b:zettel_anchor_separator variable to text",
       function()
        vim.b.zettel_anchor_separator = "---"
        assert.same("1910291645---arated", A.prepend("1910291645", "arated"))
    end)
end)

describe("extract", function()
    it("should get the default anchor from a string of text", function()
        assert.same("2010261208", A.extract(
                        "/home/office/docs/2010261208 we are the champions.md"))
    end)
    it("should return nil when default anchor not contained", function()
        assert.same(nil, A.extract(
                        "/home/office/docs/10261208 we are the champions.md"))
    end)
    it("should use the anchor set in options", function()
        vim.g.zettel_anchor_regex = '[%u][%l][%d][%d][%d][%d]'
        assert.same("Fa1984", A.extract(
                        "/home/office/docs/Fa1984_we are the champions.md"))
    end)
    it("should use the anchor regex argument if one is passed", function()
        assert.same("bO133T",
                    A.extract(
                        "/home/office/docs/bO133T-we are the champions.md",
                        "[%l][%u][%d][%d][%d][%u]"))
    end)
end)

describe("list", function()
    it("should return a set of anchors", function()
        local anchor_fct = function()
            return {
                ["2010261208"] = "/path/to/my/anchor.md",
                ["2001011212"] = "/path/to/my/other_anchor.md"
            }
        end
        assert.same({
            ["2010261208"] = "/path/to/my/anchor.md",
            ["2001011212"] = '/path/to/my/other_anchor.md'
        }, A.list(anchor_fct))
    end)
end)

describe("check_anchor_exists", function()
    before_each(function()
        Anchor_fct = function()
            return {
                ["2010261208"] = "/path/to/my/anchor.md",
                ["2001011212"] = "/path/to/my/other_anchor.md"
            }
        end
    end)
    it("returns true if anchor in existing set",
       function() assert.is_true(A.is_duplicate('2001011212', Anchor_fct)) end)
    it("returns false if anchor not in existing set",
       function() assert.is_false(A.is_duplicate('2001011210', Anchor_fct)) end)
end)
