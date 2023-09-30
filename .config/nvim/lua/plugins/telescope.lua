return {
    {
        "jvgrootveld/telescope-zoxide",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
        config = function()
            local z_utils = require("telescope._extensions.zoxide.utils")

            require('telescope').setup({
                defaults = {
                    dynamic_preview_title = true,
                },
                extensions = {
                    zoxide = {
                        prompt_title = "[ Walking on the shoulders of TJ ]",
                        mappings = {
                            default = {
                                after_action = function(selection)
                                    print("Update to (" .. selection.z_score .. ") " .. selection.path)
                                end
                            },
                            ["<C-s>"] = {
                                before_action = function(selection) print("before C-s") end,
                                action = function(selection)
                                    vim.cmd.edit(selection.path)
                                end
                            },
                            -- Opens the selected entry in a new split
                            ["<C-q>"] = { action = z_utils.create_basic_command("split") },
                        },
                    },
                },
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").load_extension('zoxide')
            require('telescope').setup({
                defaults = {
                    dynamic_preview_title = true,
                },
            })
        end
    },
}
