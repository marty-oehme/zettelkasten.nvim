local ls = require 'zettelkasten.list'
-- these tests, I suppose, only work on unix due to the file structure

local function simple_api_mock(files)
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

describe("get_anchors_and_paths", function()
    before_each(function() get_api_mock = simple_api_mock end)
    after_each(function() _G.vim = nil end)

    it("should return anchor-keyed table pointing to filename of zettel",
       function()
        local file_list = {"1910291645 this-is-a-testfile.md"}
        _G.vim = get_api_mock(file_list)

        local expected = {["1910291645"] = "1910291645 this-is-a-testfile.md"}
        assert.same(expected, ls.get_anchors_and_paths("someDir"))
    end)

    it("should ignore any malformed files", function()
        local file_list = {
            "2010261208 this-should-be-picked-up.md",
            "1910291645 this-is-a-testfile.md", "this-is-not-a-testfile.md",
            "1910271456 this-is-wrong-extension.txt", "1812 this-is-ignored.md"
        }
        _G.vim = get_api_mock(file_list)

        local expected = {
            ["1910291645"] = "1910291645 this-is-a-testfile.md",
            ["2010261208"] = "2010261208 this-should-be-picked-up.md"
        }
        assert.same(expected, ls.get_anchors_and_paths("someDir"))
    end)

    it("should recurse into directories if recursive argument passed in ",
       function()
        local files = {
            {"1910271456 testfile.md", "file"},
            {"more-notes-here", "directory"},
            {"2010261208 another-testfile.md", "file"}
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
        _G.vim = vim_api_mock

        ls.get_anchors_and_paths("path/to/startingdir", true)

        assert.spy(vim_api_mock.loop.fs_scandir).was_called(2)
        assert.spy(vim_api_mock.loop.fs_scandir).was_called_with(
            "path/to/startingdir/more-notes-here")
    end)

    it("should append all notes found in subdirectories when recursing",
       function()
        local outer_files = {
            "subdir", "1234567890 myfile.md", "2345678901 another.md"
        }
        local inner_files = {
            "2222222222 should-be-present.md",
            "3333333333 should-also-be-present.md"
        }
        local files = outer_files
        -- assert.is_true("not implemented")
        local vim_api_mock = {
            g = {},
            b = {},
            loop = {
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
            }
        }
        _G.vim = vim_api_mock
        local expected = {
            ["1234567890"] = "1234567890 myfile.md",
            ["2345678901"] = "2345678901 another.md",
            ["2222222222"] = "2222222222 should-be-present.md",
            ["3333333333"] = "3333333333 should-also-be-present.md"
        }
        assert.same(expected, ls.get_anchors_and_paths('mydirectory', true))
    end)

    it("should adhere to the zettel extension defined in options", function()
        local file_list = {"1910291645 myfile.wiki", "2345678901 another.wiki"}
        _G.vim = get_api_mock(file_list)
        vim.g['zettel_extension'] = '.wiki'

        local expected = {
            ["1910291645"] = "1910291645 myfile.wiki",
            ["2345678901"] = "2345678901 another.wiki"
        }

        assert.same(expected,
                    ls.get_anchors_and_paths('mydirectory', false, vim.g))

    end)

    it("should default to the zettel root dir",
       function() pending("not implemented") end)
end)

describe("get_zettel", function()
    it("should return the correct zettel by id", function()
        local file_list = {
            ["1910291645"] = "1910291645 myfile.md",
            ["2345678901"] = "2345678901 another.md"
        }
        _G.vim = simple_api_mock(file_list)

        assert.same("1910291645 myfile.md",
                    ls.get_zettel("1910291645", file_list))
    end)

    it("should default to the zettel root dir if no list passed in", function()
        local file_list = {"1910291645 myfile.wiki", "2345678901 another.wiki"}
        _G.vim = simple_api_mock(file_list)

        pending("not implemented")
        assert.same("1910291645 myfile.wiki", ls.get_zettel("1910291645"))
    end)
end)
