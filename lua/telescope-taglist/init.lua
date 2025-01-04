local M = {}

function M.setup()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    error "This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
  end
  telescope.load_extension("taglist")
end

return M
