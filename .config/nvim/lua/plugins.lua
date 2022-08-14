local status, packer = pcall(require, 'packer')
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Package Manager
  use {
    'svrana/neosolarized.nvim', -- Theme
    requires = { 'tjdevries/colorbuddy.nvim' }
  }
  use 'kyazdani42/nvim-web-devicons' -- File Icons
  use 'hoob3rt/lualine.nvim' -- Statusline
  use 'akinsho/nvim-bufferline.lua' -- Vim Line
  use 'norcalli/nvim-colorizer.lua' -- Preview HEX color

  use 'L3MON4D3/LuaSnip' -- Snippets
  use 'windwp/nvim-autopairs' -- Auto brackets
  use 'tpope/vim-surround' -- Surround
  use 'windwp/nvim-ts-autotag' -- Auto complete end tag
  use 'dinhhuy258/git.nvim' -- Git
  use 'lewis6991/gitsigns.nvim' -- Show git status icons
  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'nvim-telescope/telescope.nvim' -- File Viewer
  use 'nvim-telescope/telescope-file-browser.nvim' -- File browser
  use 'https://github.com/preservim/tagbar' -- Tagbar for code navigation
  use 'https://github.com/terryma/vim-multiple-cursors' -- CTRL + N for multiple cursors

  use 'neovim/nvim-lspconfig' -- LSP
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim' -- Pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for newvim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use {
    'nvim-treesitter/nvim-treesitter', -- Highlighter
    run = ':TSUpdate'
  }
  use 'jose-elias-alvarez/null-ls.nvim' -- Prettier
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    run = ':!sudo apt install universal-ctags'
  }
  use "williamboman/mason.nvim" -- LSP Manager
  use "williamboman/mason-lspconfig.nvim"

end)
