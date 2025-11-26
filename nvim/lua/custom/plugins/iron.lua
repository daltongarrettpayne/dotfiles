return {
  'Vigemus/iron.nvim',
  config = function()
    local iron = require 'iron.core'
    local common = require 'iron.fts.common'
    local view = require 'iron.view'
    local venv = os.getenv 'VIRTUAL_ENV'
    local python_path

    if venv and vim.fn.filereadable(venv .. '/bin/ipython3') == 1 then
      python_path = venv .. '/bin/ipython3'
    elseif venv and vim.fn.filereadable(venv .. '/bin/python3') == 1 then
      python_path = venv .. '/bin/python3'
    elseif venv and vim.fn.filereadable(venv .. '/bin/python') == 1 then
      python_path = venv .. '/bin/python'
    elseif venv and vim.fn.filereadable(venv .. '/bin/ipython') == 1 then
      python_path = venv .. '/bin/ipython'
    else
      python_path = 'python3' -- fallback to system python
    end

    iron.setup {
      config = {
        repl_open_cmd = view.split '40%',
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { 'zsh' },
          },
          python = {
            command = function()
              if python_path:match 'ipython' then
                return { python_path, '--no-autoindent' }
              else
                return { python_path }
              end
            end,
            format = common.bracketed_paste_python,
            block_dividers = { '# %%', '#%%' },
          },
        },
        repl_filetype = function(bufnr, ft)
          return ft
        end,
        repl_open_cmd = 'vertical botright 80 split',
      },
      keymaps = {
        toggle_repl = '<space>rr',
        restart_repl = '<space>rR',
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>si',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        send_code_block = '<space>sb',
        send_code_block_and_move = '<space>sn',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>s<space>',
        exit = '<space>sq',
        clear = '<space>cl',
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    }

    vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
  end,
}
