local skipped_servers = {
  "angularls",
  "ansiblels",
  "antlersls",
<<<<<<< HEAD
  "ccls",
  "csharp_ls",
  "cssmodules_ls",
  -- "dartls",
  "denols",
  "docker_compose_language_service",
  "ember",
=======
  "azure_pipelines_ls",
  "ccls",
  "custom_elements_ls",
  "omnisharp",
  "cssmodules_ls",
  "denols",
  "docker_compose_language_service",
  "ember",
  "emmet_language_server",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "emmet_ls",
  "eslint",
  "eslintls",
  "glint",
  "golangci_lint_ls",
  "gradle_ls",
  "graphql",
<<<<<<< HEAD
=======
  "java_language_server",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "jedi_language_server",
  "ltex",
  "neocmake",
  "ocamlls",
  "phpactor",
  "psalm",
  "pylsp",
<<<<<<< HEAD
=======
  "pylyzer",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "pyre",
  "quick_lint_js",
  "reason_ls",
  "rnix",
  "rome",
  "ruby_ls",
<<<<<<< HEAD
=======
  "rubocop",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "ruff_lsp",
  "scry",
  "solang",
  "solc",
  "solidity_ls",
<<<<<<< HEAD
=======
  "solidity_ls_nomicfoundation",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "sorbet",
  "sourcekit",
  "sourcery",
  "spectral",
  "sqlls",
  "sqls",
<<<<<<< HEAD
=======
  "standardrb",
>>>>>>> 14b0878 (upgrade new lunar vim)
  "stylelint_lsp",
  "svlangserver",
  "tflint",
  "unocss",
  "verible",
  "vtsls",
  "vuels",
}

local skipped_filetypes = { "markdown", "rst", "plaintext", "toml", "proto" }

local join_paths = require("lvim.utils").join_paths

return {
  templates_dir = join_paths(get_runtime_dir(), "site", "after", "ftplugin"),
<<<<<<< HEAD
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = lvim.icons.diagnostics.Error },
        { name = "DiagnosticSignWarn",  text = lvim.icons.diagnostics.Warning },
        { name = "DiagnosticSignHint",  text = lvim.icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo",  text = lvim.icons.diagnostics.Information },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          return string.format("%s [%s]", d.message, code):gsub("1. ", "")
        end
        return d.message
      end,
    },
  },
  document_highlight = false,
  code_lens_refresh = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
=======
  ---@deprecated use vim.diagnostic.config({ ... }) instead
  diagnostics = {},
  document_highlight = false,
  code_lens_refresh = true,
>>>>>>> 14b0878 (upgrade new lunar vim)
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_configuration = {
    ---@usage list of servers that the automatic installer will skip
    skipped_servers = skipped_servers,
    ---@usage list of filetypes that the automatic installer will skip
    skipped_filetypes = skipped_filetypes,
  },
  buffer_mappings = {
    normal_mode = {
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
<<<<<<< HEAD
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto Definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration" },
=======
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
>>>>>>> 14b0878 (upgrade new lunar vim)
      ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
      ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature help" },
      ["gl"] = {
        function()
<<<<<<< HEAD
          local config = lvim.lsp.diagnostics.float
          config.scope = "line"
          vim.diagnostic.open_float(0, config)
=======
          local float = vim.diagnostic.config().float

          if float then
            local config = type(float) == "table" and float or {}
            config.scope = "line"

            vim.diagnostic.open_float(config)
          end
>>>>>>> 14b0878 (upgrade new lunar vim)
        end,
        "Show line diagnostics",
      },
    },
    insert_mode = {},
    visual_mode = {},
  },
  buffer_options = {
    --- enable completion triggered by <c-x><c-o>
    omnifunc = "v:lua.vim.lsp.omnifunc",
    --- use gq for formatting
    formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
  },
  ---@usage list of settings of nvim-lsp-installer
  installer = {
    setup = {
      ensure_installed = {},
      automatic_installation = {
        exclude = {},
      },
    },
  },
  nlsp_settings = {
    setup = {
      config_home = join_paths(get_config_dir(), "lsp-settings"),
      -- set to false to overwrite schemastore.nvim
      append_default_schemas = true,
      ignored_servers = {},
      loader = "json",
    },
  },
  null_ls = {
    setup = {
      debug = false,
    },
    config = {},
  },
  ---@deprecated use lvim.lsp.automatic_configuration.skipped_servers instead
  override = {},
  ---@deprecated use lvim.lsp.installer.setup.automatic_installation instead
  automatic_servers_installation = nil,
}
