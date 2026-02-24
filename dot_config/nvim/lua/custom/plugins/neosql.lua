return {
  'h4kbas/neosql.nvim',
  lazy = true,
  cmd = { 'NeoSqlConnect', 'NeoSqlProjectLoad', 'NeoSqlProjectList' },
  keys = {
    { '<leader>Dc', '<cmd>NeoSqlConnect<cr>', desc = 'Connect to database' },
    { '<leader>Do', '<cmd>NeoSqlOpen<cr>', desc = 'Open NeoSQL views' },
    { '<leader>Dx', '<cmd>NeoSqlClose<cr>', desc = 'Close NeoSQL views' },
    { '<leader>Dd', '<cmd>NeoSqlDisconnect<cr>', desc = 'Disconnect' },
    { '<leader>Ds', '<cmd>NeoSqlProjectSave<cr>', desc = 'Save project' },
    { '<leader>Dl', '<cmd>NeoSqlProjectLoad<cr>', desc = 'Load project' },
    { '<leader>DL', '<cmd>NeoSqlProjectList<cr>', desc = 'List projects' },
    {
      '<leader>D?',
      function()
        local lines = {
          '  NeoSQL Keybindings',
          '  ══════════════════════════════════',
          '',
          '  Query Window:',
          '    <CR>  Execute query',
          '    e     Focus result',
          '    t     Focus table list',
          '',
          '  Result Window:',
          '    e     Edit cell',
          '    i     Insert row',
          '    dd    Delete row',
          '    a     Apply changes',
          '    c     Undo all table changes',
          '    u     Undo cell change',
          '    U     Undo row changes',
          '    s     Export (CSV/JSON)',
          '    q     Focus query',
          '',
          '  Table List:',
          '    <CR>  Select table',
          '    i     INSERT template',
          '    s     SELECT template',
          '    u     UPDATE template',
          '    d     DELETE template',
          '    e     Edit table properties',
          '    q     Focus query',
          '',
          '  Press any key to close',
        }
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        local width = 42
        local height = #lines
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2,
          style = 'minimal',
          border = 'rounded',
        })
        vim.bo[buf].modifiable = false
        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf })
        vim.keymap.set('n', 'q', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf })
        vim.api.nvim_create_autocmd('BufLeave', {
          buffer = buf,
          once = true,
          callback = function()
            pcall(vim.api.nvim_win_close, win, true)
          end,
        })
      end,
      desc = 'Show keybindings help',
    },
  },
  config = function()
    require('neosql').setup({
      keybindings = {
        query = {
          execute = '<CR>',
          focus_result = 'e',
          focus_table_list = 't',
        },
        result = {
          edit_cell = 'e',
          insert_row = 'i',
          delete_row = 'dd',
          apply_changes = 'a',
          undo_table_changes = 'c',
          undo_cell_change = 'u',
          undo_row_changes = 'U',
          export = 's',
          focus_query = 'q',
        },
        table_list = {
          select_table = '<CR>',
          insert_template = 'i',
          select_template = 's',
          update_template = 'u',
          delete_template = 'd',
          edit_table_properties = 'e',
          focus_query = 'q',
        },
      },
    })

    -- Register which-key group
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add({
        { '<leader>D', group = '[D]atabase (NeoSQL)' },
      })
    end
  end,
}
