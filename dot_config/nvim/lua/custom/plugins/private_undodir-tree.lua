return {
  'pixelastic/vim-undodir-tree',
  config = function()
    -- The plugin automatically handles undo file storage
    -- It creates a directory tree structure instead of encoding paths with %
    -- This prevents filename length issues with deeply nested paths
    vim.o.undofile = true
  end,
}
