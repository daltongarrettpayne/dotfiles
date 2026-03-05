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
    { '<leader>ct', '<cmd>ClaudeCode<cr>', desc = '[C]laude [T]oggle' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = '[C]laude [F]ocus' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[C]laude [S]end selection' },
    { '<leader>cy', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[C]laude accept (yes)' },
    { '<leader>cn', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[C]laude deny (no)' },
  },
}
