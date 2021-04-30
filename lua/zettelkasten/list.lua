local ls = {}
-- TODO rename to files.lua? since it's the only module interacting solely w/ the file system

local o = require 'zettelkasten.options'

local function isDirectory(ftype)
    if ftype == 'directory' then return true end
    return false
end

local function isFile(ftype)
    if ftype == 'file' then return true end
    return false
end

local function cleanPath(path)
    if path:match("^~") then path = os.getenv("HOME") .. path:sub(2) end
    return path
end

-- Returns a set of valid zettels in the form
-- { anchor = fullpathname }.
-- Takes a (flat) set of files to iterate over in the form that
-- get_all_files produces.
-- TODO transform paths:
--    * to ensure / at the end (or no /) gets taken into account
function ls.get_anchors_and_paths(fileset)
    -- TODO check for duplicates and warn user
    local zettel = {}
    local anchorreg = '^.*/?(' .. o.anchor().regex .. ')[^/]*%' ..
                          o.zettel().extension .. '$'

    for full_path, name in pairs(fileset) do
        local anchor = string.match(name, anchorreg)
        if anchor then zettel[tostring(anchor)] = full_path end
    end
    return zettel
end

-- Returns a set of all files at the target directory, as well
-- as subdirectories if the recursive argument is set to true.
-- Set has the form { "full/path/name.md" = "name.md" }
function ls.get_all_files(path, recursive)
    local f = {}
    path = cleanPath(path)

    local handle = vim.loop.fs_scandir(path)
    while handle do
        local name, ftype = vim.loop.fs_scandir_next(handle)
        if not name then break end

        if isDirectory(ftype) and recursive then
            local subdir = ls.get_all_files(path .. "/" .. name, true)
            for k, v in pairs(subdir) do f[tostring(k)] = v end
        end

        if isFile(ftype) then f[tostring(path .. "/" .. name)] = name end
    end

    return f
end

-- Returns the path to the zettel defined by the anchor argument.
-- Take a list of zettel as an optional variable, without which
-- it will use the (recursive) results of the zettel_root directory.
function ls.get_zettel(anchor, all)
    local zettels = all or
                        ls.get_anchors_and_paths(
                            ls.get_all_files(o.zettel().rootdir, true))
    if not zettels then return end

    return zettels[anchor]
end

return ls
