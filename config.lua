--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- Enable powershell as your default shell
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=
  ]]

-- Set a compatible clipboard manager
vim.g.clipboard = {
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
}

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"

lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua,*.dart,*.js,*.ts,*.jsx,*.tsx,*.py,*.go,*.cs",
  timeout = 1000,
}

-- -- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
--[[ vim.opt.guifont = "monospace:h12" ]]
lvim.keys.normal_mode["K"] = ":lua vim.lsp.buf.hover()<CR>"
lvim.keys.normal_mode["gd"] = ":lua vim.lsp.buf.definition()<CR>"



-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

lvim.autocommands = {
  {
    { "BufEnter", "Filetype" },
    {
      desc = "Open mini.map and exclude some filetypes",
      pattern = { "*" },
      callback = function()
        local exclude_ft = {
          "qf",
          "NvimTree",
          "toggleterm",
          "TelescopePrompt",
          "alpha",
          "netrw",
        }

        local map = require('mini.map')
        if vim.tbl_contains(exclude_ft, vim.o.filetype) then
          vim.b.minimap_disable = true
          map.close()
        elseif vim.o.buftype == "" then
          map.open()
        end
      end,
    },
  },
}



-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- ensure these parsers are always installed, useful for those without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }
-- `/` cmdline setup.
-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  --     {
  --       "folke/trouble.nvim",
  --       cmd = "TroubleToggle",
  --
  --}

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        char = "▏",
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        use_treesitter = true,
      }
    end
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(
        { "css", "scss", "html", "javascript", "dart", "typescript", "go", "c_sharp", "python" },
        {
          rgb = true,      -- #rgb hex codes
          rrggbb = true,   -- #rrggbb hex codes
          rrggbbaa = true, -- #rrggbbaa hex codes
          rgb_fn = true,   -- css rgb() and rgba() functions
          hsl_fn = true,   -- css hsl() and hsla() functions
          css = true,      -- enable all css features: rgb_fn, hsl_fn, names, rgb, rrggbb
          css_fn = true,   -- enable all css *functions*: rgb_fn, hsl_fn
        }
      )
    end,
  },



  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
          'rescript',
          'xml',
          'php',
          'markdown',
          'glimmer', 'handlebars', 'hbs'
        },
        skip_tags = {
          'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
          'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr', 'menuitem'
        }
      })
    end,
  },

  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     require("nvim-dap").setup({

  --     })
  --   end
  -- },
  {
    "dart-lang/dart-vim-plugin",
    ft = { "dart" },
    --[[ config = function() ]]
    --require("dart-vim-plugin").setup({})
    -- cấu hình format_on_save cho dart
    -- vim.api.nvim_exec([[
    --   augroup dart_format_on_save
    --   autocmd!
    --   autocmd bufwritepre *.dart :silent! dartfmt
    --   augroup end
    -- ]], false)
    --[[ end ]]
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    after = "mason-lspconfig.nvim",
    config = function()
      require("flutter-tools").setup({
        -- lsp = {
        --   skip_setup = { "dartls" },
        -- },
        widget_guides = {
          enabled = true,

        },
        debugger = {
          -- integrate with nvim dap + install dart code debugger
          enabled = true,
          run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |::help dap.set_exception_breakpoints()help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          register_configurations = function(_)
            require("dap").adapters.dart = {
              type = "executable",
              command = "node",
              args = { "C:/Users/minhg/Downloads/Development/Dart-Code/out/dist/debug.js", "flutter" }
            }

            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch flutter",
                dartSdkPath = "C:/flutter/bin/cache/dart-sdk/",
                flutterSdkPath = "C:/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              }

            }
            require("dap").set_log_level("DEBUG")
            -- require("dap").adapters.dart = {
            --   type = "executable",
            --   command = "node",
            --   args = { "C:\\Users\\minhg\\Dart-Code\\out\\dist\\debug.js", "flutter" }
            -- }
          end,
          flutter_path = "C:\\flutter\\bin\\flutter.bat", -- <-- this takes priority over the lookup
          flutter_lookup_cmd = nil,                       -- example "dirname $(which flutter)" or "asdf where flutter"
          fvm = false,                                    -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
          dev_log = {
            enabled = true,
            open_cmd = "tabedit", -- command to use to open the log buffer
          },
          dev_tools = {
            autostart = true,         -- autostart devtools server if not detected
            auto_open_browser = true, -- Automatically opens devtools in the browser
          },
          outline = {
            open_cmd = "30vnew", -- command to use to open the outline buffer
            auto_open = false    -- if true this will open the outline automatically when it is first populated
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = { "C:\\flutter" },
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
          }
        }
      })
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("nvim-dap-ui").setup({})
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end
  },
  -- {
  --   "mattn/vim-lsp-settings",
  --   config = function()
  --     require("vim-lsp-settings").setup({})
  --   end
  -- },


  -- {
  --   "Nash0x7E2/awesome-flutter-snippets",
  --   config = function()
  --     require('Nash0x7E2/awesome-flutter-snippets').setup({})
  --   end
  -- },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "nvim-treesitter/playground",
    event = "BufRead",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,             -- Width of the floating window
        height = 25,             -- Height of the floating window
        default_mappings = true, -- Bind default mappings
        debug = false,           -- Print debug information
        opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil,    -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>"),
        --  vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>"),
        --  vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>"),
      }
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "npxbr/glow.nvim",
    ft = { "markdown" }
    -- run = "yay -S glow"
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,       -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    "turbio/bracey.vim",
    cmd = { "Bracey", "BracyStop", "BraceyReload", "BraceyEval" },
    build = "npm install --prefix server",
  },
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  {
    "echasnovski/mini.map",
    branch = "stable",
    config = function()
      require('mini.map').setup()
      local map = require('mini.map')
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = 'DiagnosticFloatingError',
            warn  = 'DiagnosticFloatingWarn',
            info  = 'DiagnosticFloatingInfo',
            hint  = 'DiagnosticFloatingHint',
          }),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot('4x2'),
        },
        window = {
          side = 'right',
          width = 20, -- set to 1 for a pure scrollbar :)
          winblend = 15,
          show_integration_count = false,
        },
      })
    end
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
}

--
-- }
--

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
