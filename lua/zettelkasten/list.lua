local ls = {}

local o = require 'zettelkasten.options'

local function isDirectory(ftype)
    if ftype == 'directory' then return true end
    return false
end

-- TODO transform paths:
--    * to absolute value (e.g. ~ to home, scandir needs absolute)
--    * to ensure / at the end (or no /) gets taken into account
function ls.get_anchors_and_paths(path, recursive, options)
    options = options or {}
    -- TODO check for duplicates and warn user
    local zettel = {}
    -- TODO let user set as option, at least remove magic var
    local anchorreg = '^.*/?([%d][%d][%d][%d][%d][%d][%d][%d][%d][%d])[^/]*%' ..
                          o.zettel().extension .. '$'

    local handle = vim.loop.fs_scandir(path)
    while handle do
        local name, ftype = vim.loop.fs_scandir_next(handle)
        if not name then break end

        if isDirectory(ftype) and recursive then
            local subdir = ls.get_anchors_and_paths(path .. "/" .. name, true)
            for k, v in pairs(subdir) do zettel[tostring(k)] = v end
        end

        local anchor = string.match(name, anchorreg)
        if anchor then zettel[tostring(anchor)] = name end
    end
    return zettel
end

-- Returns the path to the zettel defined by the anchor argument.
-- Take a list of zettel as an optional variable, without which
-- it will use the (recursive) results of the zettel_root directory.
function ls.get_zettel(anchor, all)
    -- TODO why is there 'somepath' here?
    if not all then all = ls.get_anchors_and_paths('/home/marty/documents/notes') end

    return all[anchor]
end

return ls
