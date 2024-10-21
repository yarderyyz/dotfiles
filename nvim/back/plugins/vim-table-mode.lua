return {
  "dhruvasagar/vim-table-mode",
  config = function(PluginSpec)
    local function isAtStartOfLine(mapping)
      -- Get the text before the cursor on the current line
      local line = vim.api.nvim_get_current_line()
      local cursor_col = vim.fn.col(".") - 1
      local text_before_cursor = line:sub(1, cursor_col)

      -- Create the mapping pattern
      local mapping_pattern = "\\V" .. vim.fn.escape(mapping, "\\")

      -- Create the comment pattern
      local commentstring = vim.bo.commentstring
      commentstring = vim.fn.substitute(commentstring, "%s.*$", "", "")
      local comment_pattern = "\\V" .. vim.fn.escape(commentstring, "\\")

      -- Check if text before cursor matches the pattern
      local pattern = "^" .. ("\\v(" .. comment_pattern .. "\\v)?") .. "\\s*\\v" .. mapping_pattern .. "\\v$"
      return vim.fn.match(text_before_cursor, pattern) ~= -1
    end

    -- Create the abbreviations
    vim.api.nvim_set_keymap(
      "i",
      "<expr> <bar><bar>",
      "v:lua.isAtStartOfLine('\\|\\|') and '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' or '<bar><bar>'",
      { expr = true, noremap = true }
    )
    vim.api.nvim_set_keymap(
      "i",
      "<expr> __",
      "v:lua.isAtStartOfLine('__') and '<c-o>:silent! TableModeDisable<cr>' or '__'",
      { expr = true, noremap = true }
    )

    -- Make the function globally accessible for the mappings
    _G.isAtStartOfLine = isAtStartOfLine
  end,
}
