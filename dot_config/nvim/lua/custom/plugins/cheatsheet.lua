return {
  'sudormrfbin/cheatsheet.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>?', '<cmd>Cheatsheet<cr>', desc = '[?] Cheatsheet' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
