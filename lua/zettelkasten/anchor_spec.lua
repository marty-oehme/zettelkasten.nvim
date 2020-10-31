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
