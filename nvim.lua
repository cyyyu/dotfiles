--General configs

vim.g.mapleader = " "
vim.o.nu = true
vim.o.history = 1000
vim.o.so = 10
vim.o.wildmode = "longest:full,full"
vim.o.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*"
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.lazyredraw = true
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

vim.cmd [[
  set undodir=~/.vim_undo
  set undofile

  " Correct jsx/tsx filetype
  augroup ReactFiletypes
    autocmd!
    autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
    autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
  augroup END
]]

vim.cmd [[
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

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

map <silent> <leader>qq :q<cr>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

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

-- Plugins
local use = require("packer").use
require("packer").startup(function()
  use "wbthomason/packer.nvim"

  use {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup()
      vim.cmd [[colorscheme github_dark_default]]
    end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require "nvim-tree".setup {
        view = {
          width = 30,
          hide_root_folder = true,
        }
      }
      vim.keymap.set("n", "<c-n>", "<cmd>NvimTreeToggle<cr>", { remap = false })
      vim.keymap.set("n", "<leader>v", "<cmd>NvimTreeFindFile<cr>", { remap = false })
      vim.o.termguicolors = true
    end
  }
  use "mattn/emmet-vim"
  use "scrooloose/nerdcommenter"
  use "sheerun/vim-polyglot"
  use { "windwp/nvim-autopairs", config = function()
    require("nvim-autopairs").setup()
  end }
  use "yuttie/comfortable-motion.vim"
  use { "lukas-reineke/indent-blankline.nvim", config = function()
    vim.opt.list = true
    require("indent_blankline").setup {}
  end }

  -- fzf
  use { "junegunn/fzf", run = "./install --bin", }
  use { "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup {
        fzf_layout = "reverse",
        fzf_preview_window = "right:60%",
        fzf_colors = {
          ["fg+"] = { "fg", "Normal" },
          ["bg+"] = { "bg", "Normal" },
          ["hl+"] = { "fg", "Comment" },
          ["fg"] = { "fg", "Normal" },
          ["bg"] = { "bg", "Normal" },
          ["hl"] = { "fg", "Comment" },
        },
      }
      vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g", "<cmd>FzfLua grep<CR>",
        { noremap = true, silent = true })
    end
  }

  use { "skywind3000/asyncrun.vim", config = function()
    vim.g.asyncrun_open = 16
    vim.g.asyncrun_bell = 1
    vim.keymap.set("n", "<leader>a", "<cmd>AsyncRun ")
    vim.keymap.set("n", "<leader>as", "<cmd>AsyncStop<cr>")
    vim.keymap.set("n", "<cr>", "<cmd>call asyncrun#quickfix_toggle(16)<cr>", { noremap = false })
  end }

  use {
    "zivyangll/git-blame.vim",
    config = function()
      vim.keymap.set("n", "<leader>s", "<cmd>call gitblame#echo()<cr>")
    end
  }

  use {
    "tikhomirov/vim-glsl",
    config = function()
      vim.cmd("autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl")
    end
  }
  use "github/copilot.vim"
  use { "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        theme = "auto",
        extensions = { "nvim-tree" },
      }
    end }

  use {
    "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
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
  }

  use {
    "alx741/vim-hindent",
    config = function()
      vim.cmd [[
        augroup HaskellFormat
          autocmd!
          autocmd BufRead,BufNewFile *.hs noremap <silent> <leader>l :Hindent<cr>
        augroup END
      ]]
    end,
  }

  -- LSP configs
  -- LSP keybindings
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspAttached",
    desc = "LSP actions",
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local bufopts = { noremap = true, buffer = true }
        vim.keymap.set(mode, lhs, rhs, bufopts)
      end

      bufmap("n", "gD", vim.lsp.buf.declaration)
      bufmap("n", "gd", vim.lsp.buf.definition)
      bufmap("n", "gi", vim.lsp.buf.implementation)
      bufmap("n", "gr", vim.lsp.buf.references)
      bufmap("n", "K", vim.lsp.buf.hover)
      bufmap("n", "<leader>l", function()
        vim.lsp.buf.format { async = true }
      end)
      bufmap("n", "gl", vim.diagnostic.open_float)
      bufmap("n", "[d", vim.diagnostic.goto_prev)
      bufmap("n", "]d", vim.diagnostic.goto_next)
      bufmap("n", "go", vim.lsp.buf.type_definition)
    end
  })

  use "williamboman/mason.nvim"
  use {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end
  }
  use {
    "neovim/nvim-lspconfig",
    after = { "mason-lspconfig.nvim" },
    config = function()
      local lsp_defaults = {
        on_attach = function()
          vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
        end,
      }

      -- Extend to defaults
      local lspconfig = require("lspconfig")
      lspconfig.util.default_config = vim.tbl_deep_extend(
        "force",
        lspconfig.util.default_config,
        lsp_defaults
      )

    end
  }

  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"
  use {
    "hrsh7th/nvim-cmp",
    requires = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "harsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" },
    after = { "nvim-lspconfig" },
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
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
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

      -- Setup lspconfig.
      local lsp_servers = { "tsserver", "hls" }
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      for _, lsp in ipairs(lsp_servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities,
        }
      end
      lspconfig.sumneko_lua.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
          },
        },
      }
    end
  }
  -- End LSP configs

end)
-- End plugins
