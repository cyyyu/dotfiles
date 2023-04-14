--General configs

vim.g.mapleader = " "
vim.o.nu = true
vim.o.history = 1000
vim.o.so = 1
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*"
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"
vim.o.ignorecase = true
vim.o.smartcase = true

-- speed up rendering
vim.o.lazyredraw = true
vim.o.ttyfast = true

vim.o.showmatch = true
vim.o.mat = 2
vim.o.belloff = "all"
vim.o.tm = 500
vim.cmd("au FocusGained,BufEnter * checktime")
vim.o.encoding = "utf8"
vim.o.ffs = "unix,dos,mac"
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.lbr = true
vim.o.textwidth = 500
vim.o.smartindent = true
vim.o.updatetime = 300
vim.o.switchbuf = "useopen,usetab,newtab"
vim.o.stal = 2
vim.o.clipboard = "unnamedplus"
vim.o.cc = 80
vim.o.signcolumn = "yes"
vim.o.cmdheight = 2
vim.o.background = "dark"

-- disable netrw and use nvim-tree instead
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd [[
  set undodir=~/.vim_undo
  set undofile

  " Correct jsx/tsx filetype
  augroup ReactFiletypes
    autocmd!
    autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
    autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
  augroup END

  filetype plugin indent on
  command W w !sudo tee % > /dev/null

  syntax enable

  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>
  cnoremap <C-d> <Del>

  vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
  vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

  map <silent> <leader><cr> :noh<cr>

  map <C-j> <C-W>j
  map <C-k> <C-W>k
  map <C-h> <C-W>h
  map <C-l> <C-W>l

  nmap <silent> <leader>[ :tabprevious<cr>
  nmap <silent> <leader>] :tabnext<cr>

  map <leader>c :Bclose<cr>:tabclose<cr>gT

  map <leader>tn :tabnew<cr>
  map <leader>to :tabonly<cr>
  map <leader>tc :tabclose<cr>

  map <leader>qn :cn<cr>

  " Return to last edit position when opening files
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  map <silent> <leader>qq :q<cr>

  " delete without yanking
  nnoremap <leader>d "_d
  vnoremap <leader>d "_d
  " replace currently selected text with default register
  " without yanking it
  vnoremap <leader>P "_dP

  " resize window
  nnoremap <silent> <leader>1 :resize -12<cr>
  nnoremap <silent> <leader>2 :resize +12<cr>
  nnoremap <silent> <leader>3 :vertical resize -6<cr>
  nnoremap <silent> <leader>4 :vertical resize +6<cr>

  " To reload file
  map <silent> <leader>r :checktime<CR>

  nnoremap q: <nop>
  nnoremap Q <nop>

  command! Bclose call g:BufcloseCloseIt()
  function! g:BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
      buffer #
    else
      bnext
    endif

    if bufnr("%") == l:currentBufNum
      new
    endif

    if buflisted(l:currentBufNum)
      execute("bdelete! ".l:currentBufNum)
    endif
  endfunction

  command! DeleteHiddenBuffers call g:DeleteHiddenBuffers()
  function! g:DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      if getbufvar(buf, '&mod') == 0
        silent execute 'bwipeout' buf
      endif
    endfor
  endfunction

  function! CmdLine(str)
    call feedkeys(":" . a:str)
  endfunction

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
]]

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
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function() vim.cmd [[colorscheme gruvbox]] end,
  },

  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    dependencies = { "kyazdani42/nvim-web-devicons" },
    keys = {
      { "<c-n>",     "<cmd>NvimTreeToggle<cr>",   desc = "NvimTree" },
      { "<leader>v", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTreeFindFile" },
    },
    config = function()
      require "nvim-tree".setup {
        sort_by = "case_sensitive",
        view = {
          width = 35,
          hide_root_folder = true,
        }
      }
      vim.o.termguicolors = true
    end
  },

  "mattn/emmet-vim",
  "scrooloose/nerdcommenter",
  "sheerun/vim-polyglot",

  { "windwp/nvim-autopairs", config = true },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup {}
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { "node_modules" },
          layout_strategy = "center",
          layout_config = {
            center = {
              height = 0.6,
              preview_cutoff = 30,
              prompt_position = "top",
              width = 0.5
            },
          }
        },
      }
      vim.keymap.set("n", "<leader>p", "<cmd>Telescope find_files<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>",
        { noremap = true, silent = true })
    end
  },

  {
    "skywind3000/asyncrun.vim",
    config = function()
      vim.g.asyncrun_open = 16
      vim.g.asyncrun_bell = 1
      vim.keymap.set("n", "<leader>as", "<cmd>AsyncStop<cr>")
      vim.keymap.set("n", "<cr>", "<cmd>call asyncrun#quickfix_toggle(16)<cr>", { noremap = false })
    end
  },

  {
    "zivyangll/git-blame.vim",
    config = function()
      vim.keymap.set("n", "<leader>s", "<cmd>call gitblame#echo()<cr>")
    end
  },

  {
    "tikhomirov/vim-glsl",
    config = function()
      vim.cmd("autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl")
    end
  },

  {
    "github/copilot.vim",
    config = function()
      vim.cmd [[
        let g:copilot_filetypes = {
          \ 'yaml': v:true,
          \ 'markdown': v:true,
          \ }
      ]]
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-lua/lsp-status.nvim" },
    config = function()
      require("lualine").setup {
        extensions = { "nvim-tree" },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'require"lsp-status".status()' },
          lualine_c = { '' },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        options = { section_separators = '', component_separators = '' }
      }
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        ensure_installed = {
          "javascript",
          "typescript",
          "lua",
          "haskell"
        },
        sync_install = false,
        indent = { enable = true },
        additional_vim_regex_highlighting = false,
      }
      vim.opt.foldlevel = 20
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "jose-elias-alvarez/null-ls.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup_handlers {
        -- This is a default handler that will be called for each installed server (also for new servers that are installed during a session)
        function(server_name)
          lspconfig[server_name].setup {}
        end,
      }

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.shfmt, -- shell script formatting
          null_ls.builtins.formatting.prettierd,
        }
      })

      -- LSP keybindings
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
      vim.keymap.set("n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
      vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
      vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
      vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
      vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
      vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
      vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" },
    config = function()
      vim.cmd [[set completeopt=menu,menuone,noselect]]

      local cmp = require "cmp"

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }, {
          { name = "buffer" },
        })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })
    end
  },

  {
    "nguyenvukhang/nvim-toggler",
    config = function()
      require("nvim-toggler").setup({
        inverses = {
          ["==="] = "!==",
          ["<"] = ">",
          ["<="] = ">=",
          ["&&"] = "||",
          ["+"] = "-",
          ["*"] = "/",
        }
      })
    end
  },

  {
    "declancm/cinnamon.nvim",
    config = function()
      require("cinnamon").setup({
        extra_keymaps = true,
        extended_keymaps = true,
        hide_cursor = true,
        scroll_limit = 40,
      })
    end
  }
}, {})
