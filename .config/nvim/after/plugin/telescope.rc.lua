local status, telescope = pcall(require, 'telescope')
if (not status) then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

function Telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
  defaults = {
    --  vimgrep_arguments = {
    --   'rg',
    --   '--color=never',
    --   '--no-heading',
    --   '--with-filename',
    --   '--line-number',
    --   '--column',
    --   '--smart-case',
    --   '-uu'
    -- },
    mappings = {
      n = {
        ['q'] = actions.close
      }
    },
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
      mappings = {
        ['i'] = {
          ['<C-w>'] = function() vim.cmd('normal vbd') end,
        },
        ['n'] = {
          ['N'] = fb_actions.create,
          ['h'] = fb_actions.goto_parent_dir,
          ['/'] = function() vim.cmd('startinsert') end
        }
      }
    }
  }
}

telescope.load_extension("file_browser")

vim.keymap.set('n', ';f', function()
  builtin.find_files({
    no_ignore = true,
    hidden = true
  })
end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep({
    no_ignore = true,
    hidden = true,
  })
end)
vim.keymap.set('n', ';b', function()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = Telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)
vim.keymap.set('n', ';o', function()
  builtin.oldfiles()
end)
vim.keymap.set('n', ';m', function()
  builtin.man_pages()
end)
vim.keymap.set('n', ';j', function()
  builtin.jump_list()
end)
vim.keymap.set('n', ';h', function()
  builtin.highlights()
end)
vim.keymap.set('n', ';t', function()
  builtin.highlights()
end)
vim.keymap.set('n', ';gs', function()
  builtin.git_bcommits()
end)
vim.keymap.set('n', ';ggs', function()
  builtin.git_commits()
end)
vim.keymap.set('n', ';gs', function()
  builtin.git_status()
end)
vim.keymap.set('n', ';gb', function()
  builtin.git_branches()
end)
vim.keymap.set('n', ';gt', function()
  builtin.git_stash()
end)
