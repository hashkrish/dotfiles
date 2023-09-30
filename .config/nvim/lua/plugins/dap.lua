return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local repl = require("dap.repl")
        dapui.setup({
          controls = {
            element = "repl",
            enabled = true,
          },
          layouts = {
            {
              elements = { { id = "scopes", size = 0.25 }, { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 }, { id = "watches", size = 0.25 } },
              position = "left",
              size = 40
            },
            {
              elements = { { id = "repl", size = 1 },
                -- { id = "console", size = 0.1 },
              },
              position = "bottom",
              size = 10
            }
          },
        })

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end

        repl.commands['!'] = function() require('dap').run_last() end
        repl.commands['?'] = function() require('dap.ui.variables').scopes() end
        repl.commands['<C-d>'] = repl.exit
        repl.commands['pp'] = function(text) dap.repl.append(text) end
        repl.commands['.restart'] = dap.restart

        repl.commands = vim.tbl_extend('force', repl.commands, {
          ['<C-d>'] = function()
            dap.repl.close()
            dap.disconnect()
          end,

          ['!'] = function() require('dap').run_last() end,
          ['?'] = function() require('dap.ui.variables').scopes() end,
          ['pp'] = function(text) dap.repl.append(text) end,
          ['.restart'] = dap.restart,
        })
      end
    },


    config = function()
      vim.keymap.set('n', '\\db', function() require('dap').toggle_breakpoint() end, { desc = "Toggle breakpoint" })
      vim.keymap.set('n', '\\dr', function() require('dap').repl.open() end, { desc = "Open REPL" })
      vim.keymap.set('n', '\\dc', function() require('dap').continue() end, { desc = "Continue" })
      vim.keymap.set('n', '\\do', function() require('dap').step_over() end, { desc = "Step over" })
      vim.keymap.set('n', '\\di', function() require('dap').step_into() end, { desc = "Step into" })
      vim.keymap.set('n', '\\dO', function() require('dap').step_out() end, { desc = "Step out" })
      vim.keymap.set('n', '\\dt', function() require('dapui').toggle() end, { desc = "Toggle UI" })
      vim.keymap.set('n', '\\dR', require('dap').restart, { desc = "Restart Debugger" })

      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  }
}
