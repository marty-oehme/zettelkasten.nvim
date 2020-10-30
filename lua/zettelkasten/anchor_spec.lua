local A = require 'zettelkasten.anchor'
Test_date = {year = 2019, month = 10, day = 29, hour = 16, min = 45}

before_each(function() _G.vim = {g = {}, b = {}} end)
after_each(function() _G.vim = nil end)

describe("anchor creation", function()
    it("should return zettel anchor from time passed in",
       function() assert.same("1910291645", A.create_anchor(Test_date)) end)

    it(
        "should return zettel anchor from current moment if no argument passed in",
        function() assert.same(os.date('%y%m%d%H%M'), A.create_anchor()) end)

    it("should return nil if argument passed in is invalid", function()
        assert.is_nil(A.create_anchor("My grandmother is lovely."))
    end)
end)
