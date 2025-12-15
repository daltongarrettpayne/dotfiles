return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup {
      -- Options can be added here if needed
    }

    -- Keybinding to open grug-far
    vim.keymap.set('n', '<leader>S', function()
      require('grug-far').open()
    end, { desc = '[S]earch and replace (grug-far)' })

    -- Keybinding to search and replace for the word under cursor
    vim.keymap.set('n', '<leader>R', function()
      require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
    end, { desc = '[R]eplace word under cursor' })
  end,
}
