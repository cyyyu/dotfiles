-- General configs
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

vim.cmd([[
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

  map <leader>tn :tabnew<cr>
  map <leader>to :tabonly<cr>
  map <leader>tc :tabclose<cr>

  map <leader>qn :cn<cr>

  " Return to last edit position when opening files
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

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
]])

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
		opts = {},
		config = function()
			vim.cmd("colorscheme tokyonight-night")
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		lazy = true,
		dependencies = { "kyazdani42/nvim-web-devicons" },
		keys = {
			{ "<c-n>", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
			{ "<leader>v", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTreeFindFile" },
		},
		opts = {
			sort_by = "case_sensitive",
			view = {
				width = 38,
			},
			renderer = {
				root_folder_label = false,
			},
			git = {
				ignore = false,
			},
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

	-- fancy tabs
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
			{ "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
			{ "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
		},
	},

	"mattn/emmet-vim",
	"sheerun/vim-polyglot",

	{
		"scrooloose/nerdcommenter",
		config = function()
			vim.g.NERDSpaceDelims = 1
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
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		opts = {
			defaults = {
				-- sorting_strategy = "ascending",
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
			extensions_list = { "fzf" },
		},
		keys = {
			{ "<leader>p", "<cmd>Telescope fd<cr>", desc = "Git File" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		},
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},

	-- search/replace in multiple files
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
					"haskell",
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

	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "nvimtools/none-ls.nvim" },

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
		config = function()
			vim.cmd([[set completeopt=menu,menuone,noselect]])

			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
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
				}),
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
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

	{
		"Exafunction/codeium.vim",
		config = function()
			vim.keymap.set("i", "<C-j>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	},

	{
		"prisma/vim-prisma",
	},

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
	},

	{
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>qq",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>D",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
	},

	{ "kevinhwang91/nvim-bqf", ft = "qf" },

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = {
					"*",
				},
				user_default_options = {
					RGB = true,
					RRGGBB = true,
					names = true,
					RRGGBBAA = true,
					AARRGGBB = true,
					rgb_fn = true,
					hsl_fn = true,
					css = true,
					css_fn = true,
					mode = "background",
					tailwind = true,
					sass = {
						enable = true,
						parser = "css",
					},
					always_update = true,
				},
			})
		end,
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
}, {})

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "gD", function()
		vim.lsp.buf.declaration()
	end, opts)
	vim.keymap.set("n", "gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<leader>e", function()
		vim.diagnostic.open_float()
	end, opts)

	vim.api.nvim_set_keymap(
		"n",
		"<leader>f",
		"<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
		{ noremap = true, silent = true }
	)
end)
require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())
lsp_zero.setup()

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.select }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
	["C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-Space>"] = cmp.mapping.complete(),
	["<C-e>"] = cmp.mapping.close(),
	["<C-l>"] = cmp.mapping.confirm({
		behavior = cmp.ConfirmBehavior.insert,
		select = true,
	}),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua.with({
			filetypes = {
				"lua",
			},
		}),
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
