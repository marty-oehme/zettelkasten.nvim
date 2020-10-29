local ls = {}

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
    local anchorreg = '^.*/?([%d][%d][%d][%d][%d][%d][%d][%d][%d][%d])[^/]*%' ..
                          (options.zettel_extension or '.md') .. '$'

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

return ls
