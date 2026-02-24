return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Clean tabline showing only the active buffer name per tab
      require('mini.tabline').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
        local branch = vim.b.gitsigns_head or ''
        local bufname = vim.api.nvim_buf_get_name(0)
        local rel = vim.fn.fnamemodify(bufname, ':~:.')
        if rel == '' then rel = '[No Name]' end
        local modified = vim.bo.modified and ' [+]' or ''
        local win_width = vim.fn.winwidth(0)

        local filename
        if win_width < 60 then
          filename = vim.fn.fnamemodify(bufname, ':t') .. modified
        elseif win_width < 100 then
          filename = vim.fn.pathshorten(rel) .. modified
        else
          filename = rel .. modified
        end

        return statusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { branch } },
          '%<',
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=',
        }
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
