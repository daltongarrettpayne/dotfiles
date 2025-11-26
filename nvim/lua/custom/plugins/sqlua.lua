return {
  'xemptuous/sqlua.nvim',
  lazy = true,
  cmd = 'SQLua',
  config = function()
    require('sqlua').setup {
      load_connections_on_start = true,
      keybinds = {
        -- Executes the SQL query under the cursor
        execute_query = '<space>re',
        -- Activates the selected database connection
        -- activate_db = '<C-a>',
        -- Executes a query while in insert mode
        -- insert_execute_query = '<C-r>',
      },
    }
  end,
}
