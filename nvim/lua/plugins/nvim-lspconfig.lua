return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    require("mason").setup()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = { "pyright" },
      ensure_installed = { "black" },
      ensure_installed = { "biome" },
      ensure_installed = { "tsserver" },
    })
    require("lspconfig").pyright.setup({
      capabilities = capabilities,
    })
    require("lspconfig").biome.setup({
      capabilities = capabilities,
    })
    -- require("lspconfig").tsserver.setup({
    --   capabilities = capabilities,
    -- })
  end,
}
