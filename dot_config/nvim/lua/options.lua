-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Dim entire neovim pane when tmux pane loses focus (requires focus-events on in tmux).
-- Iterates every highlight group that has an explicit bg and replaces it with the
-- tmux inactive bg color, then restores on FocusGained.
local dim_bg = 0x0f0f14 -- matches tmux window-style inactive bg
local saved_bgs = {}

local function dim_pane()
  saved_bgs = {}
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if not hl.link and hl.bg ~= nil then
      saved_bgs[name] = hl.bg
      vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', hl, { bg = dim_bg }))
    end
  end
end

local function undim_pane()
  for name, bg in pairs(saved_bgs) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', hl, { bg = bg }))
  end
  saved_bgs = {}
end

local dim_group = vim.api.nvim_create_augroup('TmuxDim', { clear = true })
vim.api.nvim_create_autocmd('FocusLost', { group = dim_group, callback = dim_pane })
vim.api.nvim_create_autocmd('FocusGained', { group = dim_group, callback = undim_pane })

-- vim: ts=2 sts=2 sw=2 et

vim.opt.shiftwidth = 4
