--General configs

-- Use space as the leader key
vim.g.mapleader = " "

-- Show line numbers
vim.o.nu = true

-- Increase the size of the history
vim.o.history = 1000

-- Enable writing of swap files
vim.o.so = 1

-- Set the wildmode to longest:full and full
vim.o.wildmode = "longest:full,full"

-- Ignore certain file types when using wildcards
vim.o.wildignore = ".o,~,.pyc,/.git/,/.hg/,/.svn/,/.DS_Store,/node_modules/"

-- Allow < and > to move to the beginning and end of a line
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"

-- Ignore case when searching
vim.o.ignorecase = true

-- Use smart case when searching (case sensitive if uppercase)
vim.o.smartcase = true

-- Enable ttyfast for faster rendering
vim.o.ttyfast = true

-- Show matching brackets
vim.o.showmatch = true

-- Number of tenths of a second to show the matching bracket
vim.o.mat = 2

-- Turn off all bells
vim.o.belloff = "all"

-- Time in milliseconds to wait for a mapped sequence to complete
vim.o.tm = 500

-- Automatically reload files when they change on disk
vim.cmd("au FocusGained,BufEnter * checktime")

-- Set the encoding to UTF-8
vim.o.encoding = "utf8"

-- Set the file format list to Unix, DOS, and Mac
vim.o.ffs = "unix,dos,mac"

-- Expand tabs to spaces
vim.o.expandtab = true

-- Number of spaces to use for each tab
vim.o.tabstop = 2

-- Number of spaces to use for each tab in insert mode
vim.o.softtabstop = 2

-- Insert line breaks
vim.o.lbr = true

-- Set the text width to 500 characters
vim.o.textwidth = 500

-- Use smart indentation
vim.o.smartindent = true

-- Number of milliseconds of inactivity before updating the swap file
vim.o.updatetime = 300

-- Switch to open buffer if possible when closing a buffer
vim.o.switchbuf = "useopen,usetab,newtab"

-- Number of seconds to wait for a mapped sequence to complete
vim.o.stal = 2

-- Use the system clipboard for yanking, pasting, etc.
vim.o.clipboard = "unnamedplus"

-- Always show the sign column
vim.o.signcolumn = "yes"

-- Height of the command-line
vim.o.cmdheight = 1

-- Set the background to dark
vim.o.background = "dark"

-- disable netrw and use nvim-tree instead
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- enable true colors
vim.o.termguicolors = true

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
		config = function()
			require("nvim-tree").setup({
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
			})
		end,
	},

	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- fancy tabs
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
			{ "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
			{ "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
		},
		opts = {
			options = {
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					local icons = {
						Error = " ",
						Warn = " ",
						Hint = " ",
						Info = " ",
					}
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
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
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
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
		},
		keys = {
			{ "<leader>p", "<cmd>Telescope fd<cr>", desc = "Git File" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		},
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
			require("lualine").setup({
				extensions = { "nvim-tree" },
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", 'require"lsp-status".status()' },
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
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				auto_install = true,
				ensure_installed = {
					"javascript",
					"typescript",
					"lua",
					"haskell",
					"help",
				},
				sync_install = false,
				additional_vim_regex_highlighting = false,
			})
			vim.opt.foldlevel = 20
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "jose-elias-alvarez/null-ls.nvim" },
		},
		config = function()
			local lsp = require("lsp-zero")
			lsp.preset("recommended")
			lsp.ensure_installed({
				"tsserver",
			})

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
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

			lsp.set_preferences({
				suggest_lsp_servers = false,
				sign_icons = {
					Error = "",
					Warning = "",
					Hint = "",
					Information = "",
				},
			})
			lsp.on_attach(function(client, bufnr)
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
			end)

			lsp.format_mapping("<leader>f", {
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				servers = {
					["null-ls"] = {
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"lua",
						"html",
						"css",
						"scss",
					},
				},
			})

			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
			lsp.setup()

			-- config null-ls
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd,
				},
			})

			vim.diagnostic.config({
				virtual_text = true,
			})
		end,
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
				}),
			})

			-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
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
		"declancm/cinnamon.nvim",
		config = function()
			require("cinnamon").setup({
				extra_keymaps = true,
				extended_keymaps = true,
				hide_cursor = true,
				scroll_limit = 40,
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

	-- Automatically highlights other instances of the word under your cursor. This works with LSP, Treesitter, and regexp matching to find the other instances.
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

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
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
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
		-- stylua: ignore
		keys = {
			{ "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    	{ "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    	{ "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    	{ "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    	{ "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    	{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
    	{ "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
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
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = true, -- "Name" codes like Blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					AARRGGBB = true, -- 0xAARRGGBB hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					mode = "background", -- Set the display mode.
					-- Available methods are false / true / "normal" / "lsp" / "both"
					-- True is same as normal
					tailwind = true, -- Enable tailwind colors
					-- parsers can contain values used in |user_default_options|
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
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
}, {})
