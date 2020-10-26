local ZK = {}

local zettel_extension, anchor_separator

local api
if vim ~= nil then
  api = vim.api
  anchor_separator = vim.g["zettel_anchor_separator"] or vim.b["zettel_anchor_separator"] or "_"
  zettel_extension = vim.g["zettel_extension"] or vim.b["zettel_extension"] or ".md"
end
package.loaded['zettelkasten'] = nil

local anchor_separator = "_"

function ZK.init(vimapi)
  vim = vimapi or vim
  anchor_separator = vim.g["zettel_anchor_separator"] or vim.b["zettel_anchor_separator"] or "_"
  zettel_extension = vim.g["zettel_extension"] or vim.b["zettel_extension"] or ".md"
end

-- entrypoint for pressing the zettel key when the cursor
-- is either on an existing link  (it will then
-- follow it) or over text (it will then turn it into a
-- zettel link)
function ZK.follow_link()
  assert(false, "NOT IMPLEMENTED")
  return ''
end

-- Return a valid zettelkasten anchor,
-- composed of yymmddHHMM.
--
-- date can be passed in as a table containing a year, a month, a day, an hour,
-- and a minute key. Returns nil if the date passed in is invalid.
-- If no date is passed in, returns Zettel anchor for current moment.
function ZK.create_anchor(date)
  local timestamp
  if pcall(function() timestamp=os.time(date) end) then
    return os.date('%y%m%d%H%M', timestamp)
  else
    return nil
  end
end

-- Returns a link to a markdown file with the date replaced with a zettel anchor,
-- and the text cleaned up to be useful in a link.
function ZK.create_link(text, date)
  text = text or ""
  if text == "" then
    text = "" .. ZK.create_anchor(date)
  else
    text = text:lower():gsub(" ", "-")
    text = "" .. ZK.create_anchor(date) .. anchor_separator .. text
  end
  return text .. (zettel_extension or ".md")
end

return {
  init = ZK.init,
  zettel_link_create = ZK.zettel_link_create,
  create_anchor = ZK.create_anchor,
  create_link = ZK.create_link,
}
