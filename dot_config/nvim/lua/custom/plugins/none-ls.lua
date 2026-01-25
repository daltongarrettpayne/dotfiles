-- Format on save and Python import sorting with Ruff (no unused import removal)
return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvimtools/none-ls-extras.nvim', -- for Ruff formatter
  },
  config = function()
    local null_ls = require 'null-ls'

    local sources = {
      require('none-ls.formatting.ruff_format').with {
        extra_args = {}, -- Only sort imports, do not remove unused
      },
      -- Add other formatters/linters here if needed
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
