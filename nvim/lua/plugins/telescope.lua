return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
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
          sorting_strategy = 'ascending',
          layout_config = {
              prompt_position = 'top'
          },
          border = true,
          multi_icon = '',
          entry_prefix = '   ',
          prompt_prefix = '   ',
          selection_caret = ' ▶ ',
          hl_result_eol = true,
          results_title = "",
          winblend = 1
        }
      })
      local builtin = require("telescope.builtin")

      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
      --vim.keymap.set('n', '<leader>fz', require('telescope').extensions.zoxide.list, { desc = '[F]ind [Z]oxide' })
      vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })

      -- require("telescope").load_extension("ui-select")
    end,
  }
