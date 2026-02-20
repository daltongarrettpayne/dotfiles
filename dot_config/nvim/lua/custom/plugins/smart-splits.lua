return {
  'mrjones2014/smart-splits.nvim',
  lazy = false, -- Must set @pane-is-vim on startup for navigate.sh detection
  config = function()
    require('smart-splits').setup({
      at_edge = function(ctx)
        local dir = ctx.direction
        if ctx.mux then
          if ctx.mux.current_pane_at_edge(dir) then
            -- Both nvim and tmux at edge — hand off to aerospace
            vim.fn.system('aerospace focus ' .. dir)
          else
            -- Nvim at edge but tmux has panes — move tmux pane
            ctx.mux.next_pane(dir)
          end
        else
          -- No mux (not in tmux) — hand off to aerospace
          vim.fn.system('aerospace focus ' .. dir)
        end
      end,
    })

    vim.keymap.set('n', '<M-h>', require('smart-splits').move_cursor_left, { desc = 'Move to left split/pane/window' })
    vim.keymap.set('n', '<M-j>', require('smart-splits').move_cursor_down, { desc = 'Move to below split/pane/window' })
    vim.keymap.set('n', '<M-k>', require('smart-splits').move_cursor_up, { desc = 'Move to above split/pane/window' })
    vim.keymap.set('n', '<M-l>', require('smart-splits').move_cursor_right, { desc = 'Move to right split/pane/window' })

    -- Terminal mode mappings for Claude Code and other terminal buffers
    vim.keymap.set('t', '<M-h>', require('smart-splits').move_cursor_left, { desc = 'Move to left split/pane/window' })
    vim.keymap.set('t', '<M-j>', require('smart-splits').move_cursor_down, { desc = 'Move to below split/pane/window' })
    vim.keymap.set('t', '<M-k>', require('smart-splits').move_cursor_up, { desc = 'Move to above split/pane/window' })
    vim.keymap.set('t', '<M-l>', require('smart-splits').move_cursor_right, { desc = 'Move to right split/pane/window' })
  end,
}
