return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

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
      dashboard.button('f', '  Find file',       '<cmd>Telescope find_files<cr>'),
      dashboard.button('r', '  Recent files',    '<cmd>Telescope oldfiles<cr>'),
      dashboard.button('g', '  Live grep',       '<cmd>Telescope live_grep<cr>'),
      dashboard.button('c', '  collide-core',    '<cmd>cd ~/Documents/repos/collide-core | Telescope find_files<cr>'),
      dashboard.button('t', '  collide-tasks',   '<cmd>cd ~/Documents/repos/collide-tasks | Telescope find_files<cr>'),
      dashboard.button('q', '  Quit',            '<cmd>qa<cr>'),
    }

    -- Footer
    dashboard.section.footer.val = ''

    alpha.setup(dashboard.config)
  end,
}
-- vim: ts=2 sts=2 sw=2 et
