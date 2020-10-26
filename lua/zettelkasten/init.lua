local ZK = {}
package.loaded['zettelkasten'] = nil

function ZK.init()
  print(
  vim.fn.nvim_win_get_width(0),
  vim.fn.nvim_win_get_height(0)
  )
end

-- entrypoint for pressing the zettel key when the cursor
-- is either on an existing link  (it will then
-- follow it) or over text (it will then turn it into a
-- zettel link)
function ZK.zettel_link()
  ZK._test()
end

function ZK._test()
  print('follow_create_zettel')
end

return {
  init = ZK.init,
  zettel_link = ZK.zettel_link
}
