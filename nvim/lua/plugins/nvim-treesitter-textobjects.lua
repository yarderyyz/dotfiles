-- TODO: maybe put this in a utils file
local textObj = {
  func = "f",
  class = "c",
  call = "l",
  condition = "o",
}

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = "nvim-treesitter/nvim-treesitter",
  enabled = true,
  cmd = { "TSTextobjectSelect", "TSTextobjectGotoNextStart", "TSTextobjectGotoPreviousStart" },
  keys = {
    { "a<CR>", "<cmd>TSTextobjectSelect @return.outer<CR>", mode = { "x", "o" }, desc = "↩ outer return" },
    { "i<CR>", "<cmd>TSTextobjectSelect @return.inner<CR>", mode = { "x", "o" }, desc = "↩ inner return" },
    { "a/", "<cmd>TSTextobjectSelect @regex.outer<CR>", mode = { "x", "o" }, desc = " outer regex" },
    { "i/", "<cmd>TSTextobjectSelect @regex.inner<CR>", mode = { "x", "o" }, desc = " inner regex" },
    { "aa", "<cmd>TSTextobjectSelect @parameter.outer<CR>", mode = { "x", "o" }, desc = "󰏪 outer parameter" },
    { "ia", "<cmd>TSTextobjectSelect @parameter.inner<CR>", mode = { "x", "o" }, desc = "󰏪 inner parameter" },
    {
      "i" .. textObj.class,
      "<cmd>TSTextobjectSelect @class.inner<CR>",
      mode = { "x", "o" },
      desc = " inner class",
    },
    {
      "a" .. textObj.class,
      "<cmd>TSTextobjectSelect @class.outer<CR>",
      mode = { "x", "o" },
      desc = " outer class",
    },
    {
      "a" .. textObj.func,
      "<cmd>TSTextobjectSelect @function.outer<CR>",
      mode = { "x", "o" },
      desc = "󰘧 outer function",
    },
    {
      "i" .. textObj.func,
      "<cmd>TSTextobjectSelect @function.inner<CR>",
      mode = { "x", "o" },
      desc = "󰘧 inner function",
    },
    {
      "a" .. textObj.condition,
      "<cmd>TSTextobjectSelect @conditional.outer<CR>",
      mode = { "x", "o" },
      desc = "󱕆 outer condition",
    },
    {
      "i" .. textObj.condition,
      "<cmd>TSTextobjectSelect @conditional.inner<CR>",
      mode = { "x", "o" },
      desc = "󱕆 inner condition",
    },
    { "a" .. textObj.call, "<cmd>TSTextobjectSelect @call.outer<CR>", mode = { "x", "o" }, desc = "󰡱 outer call" },
    { "i" .. textObj.call, "<cmd>TSTextobjectSelect @call.inner<CR>", mode = { "x", "o" }, desc = "󰡱 inner call" },
    -- INFO outer key textobj defined via various textobjs
    { "ik", "<cmd>TSTextobjectSelect @assignment.lhs<CR>", mode = { "x", "o" }, desc = "󰌆 inner key" },
  },
  config = function()
    -- When in diff mode, we want to use the default
    -- vim text objects c & C instead of the treesitter ones.
    local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
    local configs = require("nvim-treesitter.configs")
    for name, fn in pairs(move) do
      if name:find("goto") == 1 then
        move[name] = function(q, ...)
          if vim.wo.diff then
            local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
            for key, query in pairs(config or {}) do
              if q == query and key:find("[%]%[][cC]") then
                vim.cmd("normal! " .. key)
                return
              end
            end
          end
          return fn(q, ...)
        end
      end
    end
  end,
}
