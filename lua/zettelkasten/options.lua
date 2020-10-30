local Opt = {}

-- setting defaults
local ZETTEL_EXTENSION = ".md"
local ZETTEL_LINK_STYLE = "markdown"
local ANCHOR_SEPARATOR = "_"
-- TODO zettel_root = vim.g["zettel_root"] or vim.b["zettel_root"] or "~/documents/notes",
-- TODO zettel_anchor_pattern = regex? -> needs custom creation function in `create_anchor`

function Opt.zettel()
    local options = {}
    options.extension =
        vim.g["zettel_extension"] or vim.b["zettel_extension"] or
            ZETTEL_EXTENSION
    options.link_style = vim.g["zettel_link_style"] or
                             vim.b["zettel_link_style"] or ZETTEL_LINK_STYLE

    if options.link_style ~= "wiki" and options.link_style ~= "markdown" then
        error("zettel_link_style can only be set to markdown or wiki.")
    end
    return options
end

function Opt.anchor()
    local options = {}
    options.separator = vim.g["zettel_anchor_separator"] or
                            vim.b["zettel_anchor_separator"] or ANCHOR_SEPARATOR
    return options
end

return Opt
