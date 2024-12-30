-- General configs
local vim = vim
vim.g.mapleader = " "

-- Basic settings
vim.opt.nu = true
vim.opt.history = 1000
vim.opt.swapfile = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = ".o,~,.pyc,/.git/,/.hg/,/.svn/,/.DS_Store,/node_modules/"
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.ttyfast = true
vim.opt.showmatch = true
vim.opt.mat = 2
vim.opt.belloff = "all"
vim.opt.timeoutlen = 500
vim.opt.encoding = "utf8"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.linebreak = true
vim.opt.textwidth = 500
vim.opt.smartindent = true
vim.opt.updatetime = 300
vim.opt.switchbuf = "useopen,usetab,newtab"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- Automatically reload files when they change on disk
vim.cmd("au FocusGained,BufEnter * checktime")

-- Disable netrw and use nvim-tree instead
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim_undo")
vim.opt.undofile = true

-- Correct jsx/tsx filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.jsx", "*.tsx" },
  callback = function(event)
    local ft = event.match:match("%.tsx$") and "typescriptreact" or "javascriptreact"
    vim.api.nvim_buf_set_option(event.buf, "filetype", ft)
  end,
})

-- Filetype plugin indent on
vim.cmd("filetype plugin indent on")

-- Auto-reload vimrc
vim.cmd([[
  augroup config_reload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
  augroup end
]])

-- Custom commands and key mappings
vim.cmd([[
  command W w !sudo tee % > /dev/null
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>
  cnoremap <C-d> <Del>
  map <silent> <leader><cr> :noh<cr>
  map <C-j> <C-W>j
  map <C-k> <C-W>k
  map <C-h> <C-W>h
  map <C-l> <C-W>l
  nmap <silent> <leader>[ :tabprevious<cr>
  nmap <silent> <leader>] :tabnext<cr>
  map <leader>tn :tabnew<cr>
  map <leader>to :tabonly<cr>
  map <leader>tc :tabclose<cr>
  map <leader>qn :cn<cr>
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  nnoremap <leader>d "_d
  vnoremap <leader>d "_d
  vnoremap <leader>P "_dP
  nnoremap <silent> <leader>1 :resize -12<cr>
  nnoremap <silent> <leader>2 :resize +12<cr>
  nnoremap <silent> <leader>3 :vertical resize -6<cr>
  nnoremap <silent> <leader>4 :vertical resize +6<cr>
  map <silent> <leader>r :checktime<CR>
  nnoremap q: <nop>
  nnoremap Q <nop>

  vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
  vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

  nnoremap <leader>rb :enew<CR>:r!

  function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
      call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
      call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
  endfunction

  function! CmdLine(str)
    call feedkeys(":" . a:str)
  endfunction
]])

-- Custom functions
local function delete_hidden_buffers()
  local tpbl = {}
  for i = 1, vim.fn.tabpagenr("$") do
    vim.list_extend(tpbl, vim.fn.tabpagebuflist(i))
  end
  for buf = 1, vim.fn.bufnr("$") do
    if vim.fn.bufexists(buf) == 1 and vim.fn.index(tpbl, buf) == -1 and vim.fn.getbufvar(buf, "&mod") == 0 then
      vim.cmd("bwipeout " .. buf)
    end
  end
end

vim.api.nvim_create_user_command("DeleteHiddenBuffers", delete_hidden_buffers, {})

-- Keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>")

-- End general configs

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.insert }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.insert }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.close(),
          ["<C-l>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.insert, select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-l>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jose-elias-alvarez/null-ls.nvim" },
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = "yes"
    end,
    config = function()
      -- LSP
      local lspconfig_defaults = require("lspconfig").util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        "force",
        lspconfig_defaults.capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>si", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
          end, opts)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
          vim.api.nvim_set_keymap(
            "n",
            "<leader>f",
            "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
            { noremap = true, silent = true }
          )
        end,
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua.with({ filetypes = { "lua" } }),
          null_ls.builtins.formatting.prettierd.with({
            filetypes = {
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
              "html",
              "css",
              "scss",
            },
          }),
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "eslint" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            -- https://github.com/neovim/nvim-lspconfig/pull/3232
            if server_name == "tsserver" then
              server_name = "ts_ls"
            end
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },

  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    dependencies = { "kyazdani42/nvim-web-devicons" },
    keys = {
      { "<c-n>",     "<cmd>NvimTreeToggle<cr>",   desc = "NvimTree" },
      { "<leader>v", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTreeFindFile" },
    },
    opts = {
      sort_by = "case_sensitive",
      view = { width = 38 },
      renderer = { root_folder_label = false },
      git = { ignore = false },
    },
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "[b",         "<Cmd>BufferLineCyclePrev<CR>",            desc = "Previous buffer" },
      { "]b",         "<Cmd>BufferLineCycleNext<CR>",            desc = "Next buffer" },
    },
  },
  "mattn/emmet-vim",
  "sheerun/vim-polyglot",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        padding = true,
        ignore = "^$",
        toggler = {
          ---Line-comment toggle keymap
          line = "<leader>cc",
          ---Block-comment toggle keymap
          block = "<leader>cs",
        },
      })
    end,
  },
  { "windwp/nvim-autopairs", config = true },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        {
          defaults = {
            file_ignore_patterns = { "node_modules" },
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
              i = {
                ["<c-t>"] = function(...)
                  return require("trouble.providers.telescope").open_with_trouble(...)
                end,
                ["<C-Down>"] = function(...)
                  return require("telescope.actions").cycle_history_next(...)
                end,
                ["<C-Up>"] = function(...)
                  return require("telescope.actions").cycle_history_prev(...)
                end,
                ["<C-f>"] = function(...)
                  return require("telescope.actions").preview_scrolling_down(...)
                end,
                ["<C-b>"] = function(...)
                  return require("telescope.actions").preview_scrolling_up(...)
                end,
              },
              n = {
                ["q"] = function(...)
                  return require("telescope.actions").close(...)
                end,
              },
            },
          },
        },
      })
    end,

    vim.keymap.set("n", "<leader>p", "<cmd>Telescope fd theme=get_ivy<cr>"),
    vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers theme=get_ivy<cr>"),
    vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep theme=get_ivy<cr>"),
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },
  {
    "zivyangll/git-blame.vim",
    config = function()
      vim.keymap.set("n", "<leader>s", "<cmd>call gitblame#echo()<cr>")
    end,
  },
  {
    "tikhomirov/vim-glsl",
    config = function()
      vim.cmd("autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-lua/lsp-status.nvim" },
    config = function()
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end
      require("lualine").setup({
        extensions = { "nvim-tree" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "diff", source = diff_source } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        options = { section_separators = "", component_separators = "" },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "lua",
        },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        additional_vim_regex_highlighting = false,
      })
      vim.opt.foldlevel = 20
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  {
    "nguyenvukhang/nvim-toggler",
    config = function()
      -- <leader>i
      require("nvim-toggler").setup({
        inverses = {
          ["==="] = "!==",
          ["<"] = ">",
          ["<="] = ">=",
          ["&&"] = "||",
          ["+"] = "-",
          ["*"] = "/",
        },
      })
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
    end,
  },
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set("n", "s", "<Plug>(leap-forward)", { noremap = true })
      vim.keymap.set("n", "S", "<Plug>(leap-backward)", { noremap = true })
    end,
  },
  { "prisma/vim-prisma" },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end
      map("]]", "next")
      map("[[", "prev")
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
      require("notify").setup({
        top_down = false,
      })
    end,
  },
  {
    {
      "echasnovski/mini.bufremove",
      keys = {
        {
          "<leader>qq",
          function()
            if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
              vim.cmd("qa")
            else
              require("mini.bufremove").delete(0, false)
            end
          end,
          desc = "Delete Buffer",
        },
        {
          "<leader>D",
          function()
            if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
              vim.cmd("qa")
            else
              require("mini.bufremove").delete(0, true)
            end
          end,
          desc = "Delete Buffer (Force)",
        },
      },
    },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "virtualtext",
          tailwind = true,
          sass = { enable = true, parsers = { "css" } },
          always_update = true,
        },
      })
    end,
  },

  {
    "Bekaboo/dropbar.nvim",
  },

  -- {
  -- "Exafunction/codeium.vim",
  -- config = function()
  -- vim.keymap.set("i", "<C-j>", function()
  -- return vim.fn["codeium#Accept"]()
  -- end, { expr = true })
  -- vim.keymap.set("i", "<c-;>", function()
  -- return vim.fn["codeium#CycleCompletions"](1)
  -- end, { expr = true })
  -- vim.keymap.set("i", "<c-,>", function()
  -- return vim.fn["codeium#CycleCompletions"](-1)
  -- end, { expr = true })
  -- vim.keymap.set("i", "<c-x>", function()
  -- return vim.fn["codeium#Clear"]()
  -- end, { expr = true })
  -- end,
  -- },

  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_proxy = "http://127.0.0.1:1082"
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "azure",
      azure = {
        endpoint = "https://chuanggpt.openai.azure.com",
        deployment = "gpt4o",
        api_version = "2024-06-01",
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
      },
      -- add any opts here
    },
    build = "make", -- This is optional, recommended tho. Also note that this will block the startup for a bit since we are compiling bindings in Rust.
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}, {})

vim.cmd("colorscheme tokyonight-night")
