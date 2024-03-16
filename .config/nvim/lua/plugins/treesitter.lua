return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "python", "json", "json5", "jsonc", "htmldjango" })
            end
            opts.incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-k>",
                    node_incremental = "<c-k>",
                    scope_incremental = "<c-s>",
                    node_decremental = "<c-j>",
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {},
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            local status, tsc = pcall(require, "nvim-treesitter.configs")
            if not status then
                return
            end
            tsc.setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
                            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },

                            ["a:"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/field region" },
                            ["i:"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/field region" },

                            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
                            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },

                            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
                            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },

                            ["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
                            ["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" }, -- overrides default text object block of parenthesis to parenthesis

                            ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
                            ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },

                            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * method: eg 'v' or 'o'
                        -- and should return the mode ('v', 'V', or '<c-v>') or a table
                        -- mapping query_strings to modes.
                        selection_modes = {
                            ["@parameter.outer"] = "v", -- charwise
                            ["@function.outer"] = "V", -- linewise
                            ["@class.outer"] = "<c-v>", -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true of false
                        include_surrounding_whitespace = true,
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>on"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>op"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },
    {
      "luckasRanarison/tree-sitter-hyprlang",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function() 
        vim.filetype.add({
          pattern = { [".*/hyprland%.conf"] = "hyprlang" },
        })
      end
    }
}
