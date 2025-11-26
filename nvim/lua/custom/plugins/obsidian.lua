return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '/Users/daltonpayne/Favorites/LIFE-iCloud',
      },
      {
        name = 'work',
        path = '/Users/daltonpayne/Favorites/WORK-OneDrive',
      },
    },
    ui = {
      enable = true,
    },
  },
  config = function(_, opts)
    require('obsidian').setup(opts)
    -- Set conceallevel for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
}
