local Opt = {}

-- vim setting names and defaults
local zettel_defaults = {
    extension = {vimname = "zettel_extension", default = ".md"},
    link_style = {
        vimname = "zettel_link_style",
        default = "markdown",
        valid = {markdown = true, wiki = true}
    },
    link_following = {
        vimname = "zettel_link_following",
        default = "cursor",
        valid = {cursor = true, line = true}
    }
}
local anchor_defaults = {
    separator = {vimname = "zettel_anchor_separator", default = "_"},
    regex = {
        vimname = "zettel_anchor_regex",
        default = '[%d][%d][%d][%d][%d][%d][%d][%d][%d][%d]'
    }
}

-- remaining options
-- TODO zettel_root = vim.g["zettel_root"] or vim.b["zettel_root"] or "~/documents/notes",
-- TODO zettel_anchor_pattern = regex? -> needs custom creation function in `create_anchor`

local function must_contain(set, value, name)
    if type(set) ~= "table" then return false end
    if not set[value] then
        local allvalues = ""
        for n, _ in pairs(set) do allvalues = n .. ", " .. allvalues end
        error((name or "value") .. " " .. value .. " must be one of " ..
                  allvalues:sub(1, -3))
    end
end

local function get_options(defaults)
    local options = {}
    local def = defaults
    for opt, v in pairs(def) do

        -- check for vim options set (globally or buffer), otherwise use default value
        options[opt] = vim.g[def[opt].vimname] or vim.b[def[opt].vimname] or
                           def[opt].default

        -- check correct option set for constrained value sets
        if def[opt].valid then
            must_contain(def[opt].valid, options[opt], def[opt].name)
        end
    end
    return options
end

function Opt.zettel() return get_options(zettel_defaults) end

function Opt.anchor() return get_options(anchor_defaults) end

return Opt
