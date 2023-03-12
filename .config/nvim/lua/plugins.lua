local status, packer = pcall(require, 'packer')
if (not status) then
    print("Packer is not installed")
    return
end

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
    use 'https://github.com/wbthomason/packer.nvim' -- Package Manager
    use 'https://github.com/famiu/nvim-reload' -- Reload

    -- Appearance
    use 'https://github.com/tjdevries/colorbuddy.nvim' -- Theme
    use 'https://github.com/svrana/neosolarized.nvim' -- Theme
    use 'https://github.com/nvim-tree/nvim-web-devicons' -- File Icons
    -- use 'https://github.com/hoob3rt/lualine.nvim' -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    } -- Statusline
    use 'https://github.com/akinsho/nvim-bufferline.lua' -- Vim Line
    use 'https://github.com/norcalli/nvim-colorizer.lua' -- Preview HEX color
    use 'https://github.com/folke/which-key.nvim' -- Predict next key-stroke
    -- use 'https://github.com/glepnir/dashboard-nvim' -- Dashboard on startup

    -- Code level
    use 'https://github.com/svermeulen/vim-yoink'
    use 'https://github.com/L3MON4D3/LuaSnip' -- Snippets
    use 'https://github.com/windwp/nvim-autopairs' -- Auto brackets
    use 'https://github.com/tpope/vim-surround' -- Surround
    use 'https://github.com/windwp/nvim-ts-autotag' -- Auto complete end tag
    use 'https://github.com/dinhhuy258/git.nvim' -- Git
    use 'https://github.com/lewis6991/gitsigns.nvim' -- Show git status icons
    use 'https://github.com/nvim-lua/plenary.nvim' -- Common utilities
    use 'https://github.com/nvim-telescope/telescope.nvim' -- File Viewer
    use 'https://github.com/nvim-telescope/telescope-file-browser.nvim' -- File browser
    use 'https://github.com/ThePrimeagen/harpoon' -- Harpoon
    use 'https://github.com/preservim/tagbar' -- Tagbar for code navigation
    use 'https://github.com/terryma/vim-multiple-cursors' -- CTRL + N for multiple cursors
    use 'https://github.com/terrortylor/nvim-comment' -- Comment code
    use { "folke/zen-mode.nvim", config = function() require("zen-mode").setup {} end }
    use 'junegunn/vim-easy-align' -- Align
    use 'https://github.com/jmcantrell/vim-virtualenv'
    use 'https://github.com/lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use { "NvChad/nvterm", config = function () require("nvterm").setup() end, }

    -- use 's1n7ax/nvim-terminal' -- Toggle Terminal

    use 'https://github.com/neovim/nvim-lspconfig' -- LSP
    use 'https://github.com/glepnir/lspsaga.nvim'
    use 'https://github.com/onsails/lspkind-nvim' -- Pictograms
    use 'https://github.com/hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
    use 'https://github.com/hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
    use 'https://github.com/hrsh7th/nvim-cmp' -- Completion
    use 'https://github.com/rafamadriz/friendly-snippets'
    use 'https://github.com/saadparwaiz1/cmp_luasnip' -- snippet completions
    use 'https://github.com/williamboman/mason.nvim'
    use { 'https://github.com/neoclide/coc.nvim', branch = 'release' }



    use { 'https://github.com/nvim-treesitter/nvim-treesitter', -- Highlighter
        run = ':TSUpdate' }
    use 'https://github.com/nvim-treesitter/nvim-treesitter-context' -- Context highlighter
    use 'https://github.com/jose-elias-alvarez/null-ls.nvim' -- Prettier
    use 'https://github.com/preservim/vim-markdown' -- Markdown highlight
    use {
        'https://github.com/phaazon/hop.nvim', -- hop
        branch='v2',
    }

    -- use '/home/krishnan/db/changedir'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
