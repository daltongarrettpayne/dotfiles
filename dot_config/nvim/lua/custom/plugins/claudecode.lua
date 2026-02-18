return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    diff_opts = {
      vertical_split = true,
      auto_close_on_accept = true,
      keep_terminal_focus = false,
      open_in_new_tab = true,
      hide_terminal_in_new_tab = true,
    },
    terminal = {
      split_side = "right",
      split_width_percentage = 0.4,
      snacks_win_opts = {
        keys = {
          -- Alt+[ in terminal mode enters normal mode for scrolling
          term_normal = {
            '<A-[>',
            '<C-\\><C-n>',
            mode = 't',
            desc = 'Enter normal mode to scroll'
          },
          -- q in normal mode goes back to terminal mode instead of closing
          q = {
            'q',
            function()
              vim.cmd('startinsert')
            end,
            mode = 'n',
            desc = 'Return to terminal mode'
          },
          -- Send ESC to Claude Code terminal instead of exiting terminal mode
          esc = {
            '<Esc>',
            function()
              vim.api.nvim_chan_send(vim.b.terminal_job_id, '\x1b')
            end,
            mode = 't',
            desc = 'Send ESC to Claude Code'
          },
        }
      }
    }
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
