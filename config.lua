-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Enable powershell as your default shell
vim.opt.shell = "pwsh.exe"
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
vim.opt.wrap = true

-- general
lvim.log.level = "info"

lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua,*.dart,*.js,*.ts,*.jsx,*.tsx,*.py,*.go,*.cs",
  timeout = 1000,
}
lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.builtin.which_key.setup.plugins.presets.z = true
lvim.keys.visual_mode["D"] = '"_d'
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.keys.normal_mode["K"] = ":lua vim.lsp.buf.hover()<CR>"
lvim.keys.normal_mode["gd"] = ":lua vim.lsp.buf.definition()<CR>"

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true


local dap = require "dap"
local dapui = require "dapui"
local lspconfig = require "lspconfig"
local util = require "lspconfig/util"


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters.coreclr = {
  type = 'executable',
  command = 'C:/Users/minhg/scoop/apps/netcoredbg/2.2.0-974/netcoredbg.exe',
  args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}


local on_attach = function(client, bufnr)
  -- other stuff --
  require("tailwindcss-colors").buf_attach(bufnr)
end

lspconfig["tailwindcss"].setup({
  -- other settings --
  on_attach = on_attach,
})


lvim.plugins = {
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    -- load only on require("tailwindcss-colors")
    --lazy--
    lazy = true,
    -- run the setup function after plugin is loaded
    config = function()
      -- pass config options here (or nothing to use defaults)
      require("tailwindcss-colors").setup()
    end
  },
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
          },
          lsp = {
            skip_setup = { "dartls" },
            color = {
              -- show the derived colours for dart variables
              enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
              background = false, -- highlight the background
              background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
              foreground = false, -- highlight the foreground
              virtual_text = true, -- show the highlight using virtual text
              virtual_text_str = "■", -- the virtual text character to highlight
            },
          }
        }
      })
    end
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup({
        lsp = {
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false,        -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "folke/neodev.nvim",
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
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
          "gotmpl", 'gohtmltmpl', 'tmpl', 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
          'svelte',
          'vue', 'tsx',
          'jsx',
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
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup(
        {
          enabled = true,                     -- enable this plugin (the default)
          enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,            -- show stop reason when stopped for exceptions
          commented = false,                  -- prefix virtual text with comment string
          only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
          all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
          clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
          -- display_callback = function(variable, buf, stackframe, node, options)
          --   if options.virt_text_pos == 'inline' then
          --     return ' = ' .. variable.value
          --   else
          --     return variable.name .. ' = ' .. variable.value
          --   end
          -- end,
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
          virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

          -- -- experimental features:
          all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
          -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        }
      )
    end
  },
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
    config = function()
      local conf = {
        debug = false,                    -- set to true to enable debug logging
        log_path = "debug_log_file_path", -- debug log path
        verbose = false,                  -- show debug line number

        bind = true,                      -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        doc_lines = 0,                    -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default

        floating_window = false,                -- show hint in a floating window, set to false for virtual text only mode

        floating_window_above_cur_line = false, -- try to place the floating above the current line when possible Note:
        -- will set to true when fully tested, set to false will use whichever side has more space
        -- this setting will be helpful if you do not want the PUM and floating win overlap
        fix_pos = false,    -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        --hint_prefix = icons.misc.Squirrel .. " ",     -- Panda for parameter
        hint_scheme = "Comment",
        use_lspsaga = false,                          -- set to true if you want to use lspsaga popup
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        max_height = 12,                              -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 120,                              -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
          border = "rounded",                         -- double, rounded, single, shadow, none
        },

        always_trigger = false,   -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

        auto_close_after = nil,   -- autoclose signature float win after x sec, disabled if nil.
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 200,             -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

        padding = "",             -- character to pad on left and right of signature can be ' ', or '|'  etc

        transparency = nil,       -- disabled by default, allow floating win transparent value 1~100
        shadow_blend = 36,        -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black",   -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
        timer_interval = 200,     -- default timer check interval set to lower value if you want to reduce latency
        toggle_key = nil,         -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      }


      require "lsp_signature".setup(conf)
      require "lsp_signature".on_attach(conf)
    end,
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
          width = 10, -- set to 1 for a pure scrollbar :)
          winblend = 10,
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
  {
    "dstein64/nvim-scrollview",
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'nerdtree' },
        current_only = true,
        winblend = 75,
        base = 'buffer',
        column = 80,
        signs_on_startup = { 'all' },
        diagnostics_severities = { vim.diagnostic.severity.ERROR }
      })
    end
  }
  
}
