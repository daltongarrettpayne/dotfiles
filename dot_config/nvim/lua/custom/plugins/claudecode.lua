return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    diff = {
      vertical_split = true,
      auto_close_on_accept = true,
      keep_terminal_focus = false,
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
          }
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
