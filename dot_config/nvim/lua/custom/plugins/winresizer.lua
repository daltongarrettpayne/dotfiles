return {
  'simeji/winresizer',
  keys = {
    { '<C-e>', '<cmd>WinResizerStartResize<cr>', desc = 'Enter window resize mode' },
  },
  config = function()
    -- Resize step size (default is 3)
    vim.g.winresizer_vert_resize = 3
    vim.g.winresizer_horiz_resize = 3
  end,
}
