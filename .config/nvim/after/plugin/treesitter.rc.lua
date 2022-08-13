local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    'bash',
    'css',
    'javascript',
    'json',
    'python',
    'lua',
    'tsx',
    'vim',
    'yaml',
  },
  autotag = {
    enable = true,
  }
}
