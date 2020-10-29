ZK = require'lua.zettelkasten.init'
Test_date={ year=2019, month=10, day=29, hour=16, min=45 }

describe("Zettelkasten", function()
  before_each(function()
    ZK.init({ g={}, b={} })
  end)

  describe("anchor creation", function()
    it("should return zettel anchor from time passed in", function()
      assert.same("1910291645", ZK.create_anchor(Test_date))
    end)

    it("should return zettel anchor from current moment if no argument passed in", function()
      assert.same(os.date('%y%m%d%H%M'), ZK.create_anchor())
    end)

    it("should return nil if argument passed in is invalid", function()
      assert.is_nil(ZK.create_anchor("My grandmother is lovely."))
    end)
  end)

  describe("link creation", function()
    it("should return a markdown link with only zettel anchor on no text passed in", function()
      assert.same("1910291645.md", ZK.create_link(nil, Test_date))
    end)

    it("should text to link", function()
      assert.same("1910291645_isappended.md", ZK.create_link("isappended", Test_date))
    end)

    it("should return lowercased link text", function()
      assert.same("1910291645_yesiamshouting.md", ZK.create_link("YESIAMSHOUTING", Test_date))
    end)

    it("should return spaces in text replaced with dashes", function()
      assert.same("1910291645_yes-indeed-a-space.md", ZK.create_link("yes indeed a space", Test_date))
    end)

    it("should place the contents of g:zettel_anchor_separator variable in link", function()
      vim = { g = { zettel_anchor_separator = "SEP" }, b = {}}
      ZK.init(vim)
      assert.same("1910291645SEParated.md", ZK.create_link("arated", Test_date))
    end)

    it("should append the filetype set in g:zettel_extension", function()
      vim = { g = { zettel_extension = ".something" }, b = {}}
      ZK.init(vim)
      assert.same("1910291645_theworld.something", ZK.create_link("theworld", Test_date))
    end)
  end)

  -- these tests, I suppose, only work on unix due to the file structure
  describe("zettel listing", function()
    before_each(function()
      get_api_mock = function(files)
        return {
          g = {},
          b = {},
          loop = {
            fs_scandir = function()
              if #files == 0 then
                return false
              else
                return true
              end
            end,
            fs_scandir_next = function() return table.remove(files) end
          }
        }
      end
    end)

    it("should return anchor-keyed table pointing to filename of zettel", function()
      local file_list = { "1910291645 this-is-a-testfile.md" }
      ZK.init(get_api_mock(file_list))

      local expected = { ["1910291645"] = "1910291645 this-is-a-testfile.md", }
      assert.same(expected, ZK.get_zettel_list("someDir"))
    end)

    it("should ignore any malformed files", function()
      local file_list = {
        "2010261208 this-should-be-picked-up.md",
        "1910291645 this-is-a-testfile.md",
        "this-is-not-a-testfile.md",
        "1910271456 this-is-wrong-extension.txt",
        "1812 this-is-ignored.md",
      }
      ZK.init(get_api_mock(file_list))

      local expected = {
        ["1910291645"] = "1910291645 this-is-a-testfile.md",
        ["2010261208"] = "2010261208 this-should-be-picked-up.md",
      }
      assert.same(expected, ZK.get_zettel_list("someDir"))
    end)

    it("should recurse into directories if recursive argument passed in ", function()
      local files = {
        { "1910271456 testfile.md", "file" },
        { "more-notes-here", "directory" },
        { "2010261208 another-testfile.md", "file" },
      }
      local vim_api_mock = {
          g = {},
          b = {},
          loop = mock({
            fs_scandir = function()
              if #files == 0 then
                return false
              else
                return true
              end
            end,
            fs_scandir_next = function()
              if #files == 0 then return nil end
              local fname, ftype = unpack(table.remove(files))
              return fname, ftype
            end
          })
        }
      ZK.init(vim_api_mock)

      ZK.get_zettel_list("path/to/startingdir", true)

      assert.spy(vim_api_mock.loop.fs_scandir).was_called(2)
      assert.spy(vim_api_mock.loop.fs_scandir).was_called_with("path/to/startingdir/more-notes-here")
    end)

    it("should append all notes found in subdirectories when recursing", function()
      local outer_files = { "subdir", "1234567890 myfile.md", "2345678901 another.md", }
      local inner_files = { "2222222222 should-be-present.md", "3333333333 should-also-be-present.md" }
      local files = outer_files
      -- assert.is_true("not implemented")
      local vim_api_mock = {
        g = {},
        b = {},
        loop ={
          fs_scandir = function()
            if #files == 0 then return false end
            return true
          end,
          fs_scandir_next = function()
            if #files == 0 then return nil end
            local fname, ftype = table.remove(files), 'file'
            if fname == "subdir" then
              files = inner_files
              ftype = 'directory'
            end
            return fname, ftype
          end
      }}
      ZK.init(vim_api_mock)
      local expected = {
        ["1234567890"] = "1234567890 myfile.md",
        ["2345678901"] = "2345678901 another.md",
        ["2222222222"] = "2222222222 should-be-present.md",
        ["3333333333"] = "3333333333 should-also-be-present.md",
      }
      assert.same(expected, ZK.get_zettel_list('mydirectory', true))
    end)

  end)
end)
