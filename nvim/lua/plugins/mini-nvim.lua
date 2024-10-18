return {
  {
    "echasnovski/mini.nvim",
    version = false, -- always use the latest commit
    config = function()
      require("mini.surround").setup()
    end,
    dependencies = {}, -- Add dependencies here if any
  },

  -- Add more plugins here as needed
}
