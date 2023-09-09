return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local repl = require("dap.repl")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end



      vim.keymap.set('n', '\\db', function() require('dap').toggle_breakpoint() end, { desc="Toggle breakpoint" })
      vim.keymap.set('n', '\\dr', function() require('dap').repl.open() end, { desc="Open REPL" })
      vim.keymap.set('n', '\\dc', function() require('dap').continue() end, { desc="Continue" })
      vim.keymap.set('n', '\\do', function() require('dap').step_over() end, { desc="Step over" })
      vim.keymap.set('n', '\\di', function() require('dap').step_into() end, { desc="Step into" })
      vim.keymap.set('n', '\\dO', function() require('dap').step_out() end, { desc="Step out" })
      vim.keymap.set('n', '\\dt', function() require('dapui').toggle() end, { desc="Toggle UI" })

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
  }
}
