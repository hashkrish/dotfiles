local status, yapf = pcall(require, 'yapf')
if (not status) then return end

yapf.setup {
  vim.cmd [[autocmd BufWritePre *.py :Yapf]]
}
