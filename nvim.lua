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
]]

vim.cmd [[
  " Correct jsx/tsx filetype
  augroup ReactFiletypes
    autocmd!
    autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact
    autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
  augroup END
]]

vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>")

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

nmap <silent> <A-[> :tabprev<cr>
nmap <silent> <A-]> :tabnext<cr>

map <leader>c :Bclose<cr>:tabclose<cr>gT

nmap <leader>b :Buffers<cr>

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

" Set the filetype for tsx
au BufRead,BufNewFile *.tsx set filetype=typescript

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

-- End general configs

-- Plugins

local use = require("packer").use
return require("packer").startup(function()
  use "wbthomason/packer.nvim"

  use {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.o.shortmess = vim.o.shortmess .. "c"
      -- Use `[g` and `]g` to navigate diagnostics
      vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { noremap = true, silent = true })
      vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { noremap = true, silent = true })
      -- GoTo code navigation.
      vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
      vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })
      vim.cmd([[
          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync("highlight")

          augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType typescript,json setl formatexpr=CocActionAsync("formatSelected")
            " Update signature help on jump placeholder.
            autocmd User CocJumpPlaceholder call CocActionAsync("showSignatureHelp")
          augroup end
          
          " Use CTRL-S for selections ranges.
          " Requires "textDocument/selectionRange" support of language server.
          nmap <silent> <C-s> <Plug>(coc-range-select)
          xmap <silent> <C-s> <Plug>(coc-range-select)
          
          " Add `:Format` command to format current buffer.
          command! -nargs=0 Format :call CocActionAsync("format")
          " Format with prettier
          command! -nargs=0 Prettier :CocCommand prettier.formatFile
          noremap <silent> <leader>p :Prettier<cr>
          " Formatting selected code.
          xmap <leader>p  <Plug>(coc-format-selected)
          nmap <leader>l  <Plug>(coc-format)
          
          " Add `:OR` command for organize imports of the current buffer.
          command! -nargs=0 OR   :call     CocActionAsync("runCommand", "editor.action.organizeImport")

          " "K" to show doc
          nnoremap <silent> K :call Show_documentation()<CR>
          function! Show_documentation()
            if CocAction("hasProvider", "hover")
                call CocActionAsync("doHover")
                  else
            call feedkeys("K", "in")
              endif
          endfunction

          nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
       ]])
    end
  }

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
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
  use { "windwp/nvim-autopairs", config = function ()
    require("nvim-autopairs").setup()
  end }
  use "yuttie/comfortable-motion.vim"
  use { "lukas-reineke/indent-blankline.nvim", config = function()
    vim.opt.list = true
    require("indent_blankline").setup {}
  end }

  -- fzf
  -- https://github.com/junegunn/fzf.vim
  use { "junegunn/fzf", run = ":call fzf#install()" }
  use { "junegunn/fzf.vim", config = function()
    vim.keymap.set("n", "<leader>f", "<cmd>call fzf#run(fzf#wrap({\"source\": \"rg --files --hidden\"}))<cr>")
  end }

  use { "skywind3000/asyncrun.vim", config = function()
    vim.g.asyncrun_open = 16
    vim.g.asyncrun_bell = 1
    vim.keymap.set("n", "<leader>a", "<cmd>AsyncRun ")
    vim.keymap.set("n", "<leader>as", "<cmd>AsyncStop<cr>")
    vim.keymap.set("n", "<cr>", "<cmd>call asyncrun#quickfix_toggle(16)<cr>", { noremap = false })
  end }

  use {
    "jremmen/vim-ripgrep",
    config = function()
      vim.cmd("map <leader>g :Rg -i ")
      vim.g.rg_highlight = 1
      vim.keymap.set("n", "<leader>qn", "<cmd>cn<cr>")
      vim.keymap.set("n", "<leader>qp", "<cmd>cp<cr>")
      vim.keymap.set("n", "<leader>qo", "<cmd>.cc<cr>")
    end
  }
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

  use { "Yazeed1s/minimal.nvim",
    config = function()
      vim.cmd[[colorscheme minimal-base16]]
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
          "rust",
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
      vim.cmd[[
        augroup HaskellFormat
          autocmd!
          autocmd BufRead,BufNewFile *.hs noremap <silent> <leader>p :Hindent<cr>
        augroup END
      ]]
    end,
  }
end)

-- End plugins
