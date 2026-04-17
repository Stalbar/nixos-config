return {
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "Issafalcon/neotest-dotnet",
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run nearest",
      },
      {
        "<leader>tR",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: Run file",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test: Run all (cwd)",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test: Run last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Toggle summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: Toggle output panel",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test: Open output",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: Stop",
      },
    },
    opts = function()
      local ok_dotnet, dotnet = pcall(require, "neotest-dotnet")
      if not ok_dotnet then
        return {
          adapters = {},
        }
      end

      local dotnet_adapter = dotnet({
        discovery_root = "project",
        dap = { justMyCode = false },
      })

      local base_is_test_file = dotnet_adapter.is_test_file
      dotnet_adapter.is_test_file = function(file_path)
        if type(base_is_test_file) == "function" then
          local ok, is_test = pcall(base_is_test_file, file_path)
          if ok and is_test then
            return true
          end
        end

        if type(file_path) ~= "string" or not file_path:match("%.cs$") then
          return false
        end

        local ok, lines = pcall(vim.fn.readfile, file_path)
        if not ok then
          return false
        end

        local text = table.concat(lines, "\n")
        return text:find("%[Fact") ~= nil
          or text:find("%[Theory") ~= nil
          or text:find("%[InlineData") ~= nil
          or text:find("%[MemberData") ~= nil
          or text:find("%[ClassData") ~= nil
      end

      return {
        adapters = {
          dotnet_adapter,
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 12",
        },
        quickfix = {
          enabled = false,
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
