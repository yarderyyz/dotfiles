return {
  "nvim-telescope/telescope.nvim",
  -- tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim", "catppuccin/nvim" },
  config = function()
    require("telescope").setup({
      extensions = {
        --  ["ui-select"] = {
        --    require("telescope.themes").get_dropdown({}),
        --  },
      },
      defaults = {
        file_ignore_patterns = {
          "venv/*",
          "%_%_pycache%_%_/*",
          "node%_modules/*",
          "node_modules/*",
          "terraform/*",
        },
        sort_mru = true,
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        border = true,
        multi_icon = "",
        entry_prefix = "   ",
        prompt_prefix = "   ",
        selection_caret = " ▶ ",
        hl_result_eol = true,
        results_title = "",
      },
    })
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader><space>", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
    vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })
    --vim.keymap.set('n', '<leader>fz', require('telescope').extensions.zoxide.list, { desc = '[F]ind [Z]oxide' })
    vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "[F]ind [K]eymaps" })
    vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind [B]uffers" })

    -- require("telescope").load_extension("ui-select")
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    local hl = vim.api.nvim_set_hl
    local bg_color = mocha.base
    local fg_color = mocha.mantle
    local border_color = mocha.crust -- Border color
    local prompt_bg = "#3e4452" -- Prompt background
    local selection_bg = "#2c323c" -- Selection background
    local matching_fg = "#e5c07b" -- Matching text color

    -- hl(0, "TelescopeNormal", { bg = "none" })
    -- hl(0, "TelescopeBorder", { bg = bg_color, fg = border_color })
    -- hl(0, "TelescopePromptBorder", { bg = prompt_bg, fg = border_color })
    -- hl(0, "TelescopeResultsBorder", { bg = bg_color, fg = border_color })
    -- hl(0, "TelescopePreviewBorder", { bg = bg_color, fg = border_color })
    -- hl(0, "TelescopePromptNormal", { bg = prompt_bg, fg = fg_color })
    -- hl(0, "TelescopePromptPrefix", { bg = prompt_bg, fg = matching_fg })
    -- hl(0, "TelescopeSelection", { bg = selection_bg, fg = fg_color })
    -- hl(0, "TelescopeMatching", { fg = matching_fg })
  end,
}
