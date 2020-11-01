local Opt = {}

-- setting defaults
local ZETTEL_EXTENSION      = ".md"        -- ending of zettel files
local ZETTEL_LINK_STYLE     = "markdown"   -- "wiki", sets the style of link to use
local ZETTEL_LINK_FOLLOWING = "cursor"     -- "line", sets the distance ahead to look for zettel links
local ANCHOR_SEPARATOR      = "_"          -- separtor between anchor and link text in md links
-- TODO zettel_root = vim.g["zettel_root"] or vim.b["zettel_root"] or "~/documents/notes",
-- TODO zettel_anchor_pattern = regex? -> needs custom creation function in `create_anchor`

-- constricted option sets
local ZETTEL_LINK_STYLE_OPTIONS = {markdown = true, wiki = true}
local ZETTEL_LINK_FOLLOWING_OPTIONS = { cursor = true, line = true }

local function must_contain(set, value, name)
    if type(set) ~= "table" then return false end
    if not set[value] then
        local allvalues = ""
        for n, _ in pairs(set) do allvalues = n .. ", " .. allvalues end
        error((name or "value") .. " " .. value .. " must be one of " ..
                  allvalues:sub(1, -3))
    end
end

function Opt.zettel()
    local options = {}
    options.extension =
        vim.g["zettel_extension"] or vim.b["zettel_extension"] or
            ZETTEL_EXTENSION

    options.link_style = vim.g["zettel_link_style"] or
                             vim.b["zettel_link_style"] or ZETTEL_LINK_STYLE
    must_contain(ZETTEL_LINK_STYLE_OPTIONS, options.link_style,
                 "zettel_link_style")

    options.link_following = vim.g["zettel_link_following"] or vim.b["zettel_link_following"] or ZETTEL_LINK_FOLLOWING
    must_contain(ZETTEL_LINK_FOLLOWING_OPTIONS, options.link_following, "zettel_link_following")

    return options
end

function Opt.anchor()
    local options = {}
    options.separator = vim.g["zettel_anchor_separator"] or
                            vim.b["zettel_anchor_separator"] or ANCHOR_SEPARATOR
    return options
end

return Opt
