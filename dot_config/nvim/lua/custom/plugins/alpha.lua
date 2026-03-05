return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    local function pick_project(base_dir)
      local expanded = vim.fn.expand(base_dir)
      local dirs = vim.tbl_filter(function(d)
        return vim.fn.isdirectory(d) == 1
      end, vim.fn.globpath(expanded, '*', false, true))

      require('telescope.pickers').new({}, {
        prompt_title = vim.fn.fnamemodify(expanded, ':t'),
        finder = require('telescope.finders').new_table {
          results = dirs,
          entry_maker = function(dir)
            return {
              value = dir,
              display = vim.fn.fnamemodify(dir, ':t'),
              ordinal = vim.fn.fnamemodify(dir, ':t'),
            }
          end,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(prompt_bufnr)
          require('telescope.actions').select_default:replace(function()
            require('telescope.actions').close(prompt_bufnr)
            local selection = require('telescope.actions.state').get_selected_entry()
            vim.cmd('cd ' .. selection.value)
            require('telescope.builtin').find_files()
          end)
          return true
        end,
      }):find()
    end

    -- Register as user commands so buttons can use string keybinds
    vim.api.nvim_create_user_command('CollideCore', function()
      pick_project '~/Documents/repos/collide-core'
    end, {})
    vim.api.nvim_create_user_command('CollideTasks', function()
      pick_project '~/Documents/repos/collide-tasks'
    end, {})

    -- Header
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      '                                                     ',
    }

    -- Buttons (string commands only)
    dashboard.section.buttons.val = {
      dashboard.button('c', '  collide-core',  '<cmd>CollideCore<cr>'),
      dashboard.button('t', '  collide-tasks', '<cmd>CollideTasks<cr>'),
      dashboard.button('q', '  Quit',          '<cmd>qa<cr>'),
    }

    dashboard.section.footer.val = ''

    -- Grayscale highlights
    vim.api.nvim_set_hl(0, 'AlphaHeader',   { fg = '#6b6b6b' })
    vim.api.nvim_set_hl(0, 'AlphaButtons',  { fg = '#9b9b9b' })
    vim.api.nvim_set_hl(0, 'AlphaShortcut', { fg = '#4b4b4b' })
    vim.api.nvim_set_hl(0, 'AlphaFooter',   { fg = '#3b3b3b' })

    dashboard.section.header.opts.hl   = 'AlphaHeader'
    dashboard.section.buttons.opts.hl  = 'AlphaButtons'
    dashboard.section.footer.opts.hl   = 'AlphaFooter'

    alpha.setup(dashboard.config)
  end,
}
-- vim: ts=2 sts=2 sw=2 et
