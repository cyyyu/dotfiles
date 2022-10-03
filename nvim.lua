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
        sort_by = "case_sensitive",
        view = {
          width = 35,
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

  -- telescope
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { "node_modules" },
        },
      }
      vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>",
        { noremap = true, silent = true })
    end
  }

  use { "skywind3000/asyncrun.vim", config = function()
    vim.g.asyncrun_open = 16
    vim.g.asyncrun_bell = 1
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
  use {
    "github/copilot.vim",
    config = function()
      vim.cmd [[
        let g:copilot_filetypes = {
          \ 'yaml': v:true,
          \ }
      ]]
    end
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { { "nvim-lua/lsp-status.nvim" } },
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
  }

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

  -- LSP configs
  -- LSP keybindings
  use {
    "junnplus/lsp-setup.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lsp-setup").setup({
        default_mappings = false,
        mappings = {
          gD = "lua vim.lsp.buf.declaration()",
          gd = "lua vim.lsp.buf.definition()",
          gi = "lua vim.lsp.buf.implementation()",
          gr = "lua vim.lsp.buf.references()",
          K = "lua vim.lsp.buf.hover()",
          ["<C-s>"] = "lua vim.lsp.buf.signature_help()",
          ["[d"] = "lua vim.diagnostic.goto_prev()",
          ["]d"] = "lua vim.diagnostic.goto_next()",
          ["<leader>rn"] = "lua vim.lsp.buf.rename()",
          ["<leader>ca"] = "lua vim.lsp.buf.code_action()",
          ["<leader>l"] = "lua vim.lsp.buf.format({ async = true })",
          ["<leader>e"] = "lua vim.diagnostic.open_float()",
        },
        on_attach = function() end,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        servers = {
          sumneko_lua = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                },
              },
            }
          },
          tsserver = {},
          hls = {},
        }
      })
    end
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
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
  }
  -- End LSP configs

  use {
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
  }

end)
-- End plugins
