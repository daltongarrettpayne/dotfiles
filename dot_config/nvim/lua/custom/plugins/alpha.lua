return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Picker: list immediate subdirectories of base_dir, cd + find_files on select
    local function pick_project(base_dir)
      local dirs = vim.tbl_filter(function(d)
        return vim.fn.isdirectory(d) == 1
      end, vim.fn.globpath(base_dir, '*', false, true))

      require('telescope.pickers').new({}, {
        prompt_title = vim.fn.fnamemodify(base_dir, ':t'),
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

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button('c', '  collide-core',  function() pick_project '~/Documents/repos/collide-core' end),
      dashboard.button('t', '  collide-tasks', function() pick_project '~/Documents/repos/collide-tasks' end),
      dashboard.button('q', '  Quit',          '<cmd>qa<cr>'),
    }

    dashboard.section.footer.val = ''

    alpha.setup(dashboard.config)
  end,
}
-- vim: ts=2 sts=2 sw=2 et
