return {
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local ok_ls, ls = pcall(require, "luasnip")
      if not ok_ls then
        return
      end

      ls.filetype_extend("typescriptreact", { "typescript" })
      ls.filetype_extend("javascriptreact", { "typescript" })
      ls.filetype_extend("psql", { "sql" })
      ls.filetype_extend("pgsql", { "sql" })
      ls.filetype_extend("plsql", { "sql" })
      ls.filetype_extend("csharp", { "cs" })

      local ok_vscode, vscode_loader = pcall(require, "luasnip.loaders.from_vscode")
      if ok_vscode then
        vscode_loader.lazy_load()
      end

      local ok_lua, lua_loader = pcall(require, "luasnip.loaders.from_lua")
      if ok_lua then
        lua_loader.lazy_load({
          paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
        })
      end
    end,
  },
}
