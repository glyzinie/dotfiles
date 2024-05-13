-- vim:foldmethod=marker:

-- speedtest
-- > go install github.com/rhysd/vim-startuptime@latest
-- > vim-startuptime -vimpath nvim -count 100

-- Note:
-- exists(): 変数があるか
-- executable(): コマンドがあるか

-- Reset {{{
if vim.fn.has('vim_starting') == 1 then
	-- 高速化
	vim.loader.enable()

	vim.opt.packpath="~/.config/nvim,~/.config/nvim/after"

	-- Python 2
	vim.g.loaded_python_provider = 0
	-- Python 3
	vim.g.loaded_python3_provider = 0
	-- Node.js
	vim.g.loaded_node_provider = 0
	-- Ruby
	vim.g.loaded_ruby_provider = 0
	-- Perl
	vim.g.loaded_perl_provider = 0
end
-- }}}
-- lazy.nvim {{{
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
-- }}}
-- Plugin {{{
local plugins = {
	-- Color Scheme
	{
		"folke/tokyonight.nvim",
		event = "VeryLazy",
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end
	},
	-- Notify
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			notify.setup()

			vim.notify = notify
		end
	},
	-- Tree sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ':TSUpdate',
		event = "VeryLazy",
		main = 'nvim-treesitter.configs',
		opts = {
			ensure_installed = "all",
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end
			},
			indent = {
				enable = true
			}
		}
	},
	-- Language Server Protocol
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		cmd = "LspInfo",
		config = function()
			vim.diagnostic.config({severity_sort = true})
		end
	},
	{
		"mrded/nvim-lsp-notify",
		dependencies = {
			"rcarriga/nvim-notify"
		},
		config = function()
			require('lsp-notify').setup({
				notify = require('notify'),
			})
		end
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		dependencies = {
			"neovim/nvim-lspconfig"
		},
		event = 'BufReadPre',
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonUpdate"
		},
		opts = {
			ui = {
				check_outdated_packages_on_open = false,
				border = 'single',
			}
		}
	},
	{
		"RubixDev/mason-update-all",
		dependencies = {
			"williamboman/mason.nvim"
		},
		cmd = "MasonUpdateAll"
	},
	{ -- LSP
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim"
		},
		cmd = {"LspInstall", "LspUninstall"},
		config = function()
			require('mason-lspconfig').setup{
				automatic_installation = true,
				ensure_installed = {
					'denols',
					'lua_ls'
				}
			}
			require('mason-lspconfig').setup_handlers{
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
				["lua_ls"] = function ()
					lspconfig.lua_ls.setup {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" }
								}
							}
						}
					}
				end
			}
		end
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		main = "null-ls",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
					null_ls.builtins.completion.spell,
					null_ls.builtins.diagnostics.todo_comments,
					null_ls.builtins.diagnostics.trail_space,
					null_ls.builtins.hover.dictionary,
				}
			})
		end
	},
	{ -- Linters, Formatters
		'jay-babu/mason-null-ls.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			"williamboman/mason.nvim",
			'nvimtools/none-ls.nvim',
		},
		opts = {
			handlers = {}
		}
	},
	{ -- TODO: 要検討
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		cmd = {"Trouble", "TroubleToggle"},
		config = true
	},
	{ -- TODO: 要検討
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		cmd = "Lspsaga",
		config = true
	},
	-- View
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify"
		},
		config = true
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		event = {"BufNewFile", "BufRead"},
		config = true
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
			"nvim-tree/nvim-web-devicons"
		},
		event = {"BufNewFile", "BufRead"},
		opts = {
			options = {
				theme = 'tokyonight',
				globalstatus = true
			}
		}
	},
	{
		"sitiom/nvim-numbertoggle",
		event = {"BufNewFile", "BufRead"},
	},
	{ -- Git
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = true
	},
	{ -- Now Mode
		"mvllow/modes.nvim",
		event = {"BufNewFile", "BufRead"},
		config = true
	},
	-- LLM
	{
		"codota/tabnine-nvim",
		build = "./dl_binaries.sh",
		cmd = {
			"TabnineLogin",
			"TabnineToggle",
			"TabnineStatus",
			"TabnineHub",
			"TabnineChat"
		},
		event = "InsertEnter",
		main = "tabnine",
		config = true
	},
	-- Utilities
	{ -- 括弧
		"windwp/nvim-autopairs",
		dependencies = {
			"nvim-treesitter/nvim-treesitter"
		},
		event = "InsertEnter",
		opts = {
			check_ts = true
		}
	},
	{
		"rainbowhxch/accelerated-jk.nvim",
		keys = {
			{"j", "<Plug>(accelerated_jk_gj)"},
			{"k", "<Plug>(accelerated_jk_gk)"}
		}
	},
	{
		"terryma/vim-expand-region",
		keys = {
			{"v", "<Plug>(expand_region_expand)", mode = "v"},
			{"<C-v>", "<Plug>(expand_region_shrink)", mode = "v"}
		}
	},
	{
		"kana/vim-smartword",
		keys = {
			{"w", "<Plug>(smartword-w)"},
			{"b", "<Plug>(smartword-w)"},
			{"e", "<Plug>(smartword-w)"}
		}
	}
}

local opts = {
	defaults = {
		lazy = true
	},
	checker = {
		enabled = true
	},
	diff = {
		cmd = "delta"
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			}
		}
	}
}

require('lazy').setup(plugins, opts)
-- }}}
-- Option {{{
local set = vim.opt

-- コマンドラインの履歴を10000件保存する
set.history = 10000

-- マウスを有効化
set.mouse = 'a'

-- Clipboard
set.clipboard = 'unnamedplus'

-- Open Vim internal help by K command
set.keywordprg = ':help'

-- 行頭行末の左右移動で行をまたぐ
set.whichwrap = 'b,s,h,l,<,>,[,]'

-- Toggle paste
set.pastetoggle = '<F2>'

-- grep
if vim.fn.executable('rg') == 1 then
	-- Use rg (ripgrep)
	set.grepprg = 'rg --no-heading --vimgrep'
	set.grepformat = '%f:%l:%c:%m'
end

-- 検索/置換 {{{

-- 最後尾まで検索を終えたら次の検索で先頭に移る
set.wrapscan = true

-- 置換時 g オプションをデフォルトで有効にする
set.gdefault = true

-- 置換時 プレビュー表示
set.inccommand = 'nosplit'

-- }}}
-- タブ/インデント {{{

vim.g.editorconfig = true

-- Tabキー押下時のカーソル移動幅
set.softtabstop = 4

-- タブ入力を複数の空白入力に置き換えない
set.expandtab = false

-- 画面上でタブ文字が占める幅
set.tabstop = 4

-- smartindentでずれる幅
set.shiftwidth = 4

-- 改行時に前の行の構文をチェックし次の行のインデントを増減する
set.smartindent = true

-- }}}
-- ファイル処理関連 {{{

-- 保存されていないファイルがあるときは終了前に保存確認
set.confirm = true

-- 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set.hidden = true

-- ファイル保存時にバックアップファイルを作らない
set.backup = false

-- Swap
set.swapfile = false

-- ファイル文末の改行を勝手に変更しない
if vim.fn.exists('+fixeol') == 1 then
	set.fixendofline = false
end

-- }}}
-- View {{{

set.termguicolors = true

-- 背景を黒ベースに
set.background = 'dark'

-- 行番号を表示する
set.number = true

-- 行を折り返さない
set.wrap = false

-- 2バイト文字を描画する
if vim.env.TERM_PROGRAM == "Apple_Terminal" then
	set.ambiwidth = 'double'
end

-- 不可視文字を表示
set.list = true
set.listchars = 'tab:¦ ,trail:･'

-- エディタの分割方向を設定する
set.splitbelow = true
set.splitright = true

-- 折りたたみ
set.foldcolumn = 'auto:3'
set.foldlevel = 1
set.foldmethod = 'marker'
--vim.wo.foldmethod = 'expr'

set.laststatus = 3

-- }}}
-- カーソル {{{

-- カーソル位置のカラムの背景色を変える
set.cursorcolumn = true

-- カーソル行の背景色を変える
set.cursorline = true

-- カーソルの形状を変える
set.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- }}}
-- }}}
-- Key {{{
-------------------------------------------------------------------------------
-- コマンド       ノーマルモード 挿入モード コマンドラインモード ビジュアルモード
-- map/noremap           @            -              -                  @
-- nmap/nnoremap         @            -              -                  -
-- imap/inoremap         -            @              -                  -
-- cmap/cnoremap         -            -              @                  -
-- vmap/vnoremap         -            -              -                  @
-- map!/noremap!         -            @              @                  -
-------------------------------------------------------------------------------
local map = vim.keymap.set
local silent = {silent = true}
local remap = {remap = true}

-- <CR>: 次の行へ
map('n', '<CR>', ':<C-u>call append(".", "")<CR>', silent)
-- <Tab>: 次のバッファへ
map('n', '<Tab>', ':bnext<CR>', silent)

--  MiddleMouse の無効化
map('', '<MiddleMouse>', '<Nop>', remap)
map('', '<2-MiddleMouse>', '<Nop>', remap)
map('', '<3-MiddleMouse>', '<Nop>', remap)
map('', '<4-MiddleMouse>', '<Nop>', remap)
map('i', '<MiddleMouse>', '<Nop>', remap)
map('i', '<2-MiddleMouse>', '<Nop>', remap)
map('i', '<3-MiddleMouse>', '<Nop>', remap)

-- EXモード: 無効化
map('n', 'q', '<Nop>')
map('n', 'Q', '<Nop>')

-- Y: 行末までヤンク
map('n', 'Y', 'y$')

-- +/-: 数字を変化させる
map('n', '+', '<C-a>')
map('n', '-', '<C-x>')

-- <Esc><Esc>: ハイライトの切り替え
map('n', '<Esc><Esc>', ':<C-u>set nohlsearch!<CR>', silent)

-- <ESC>: terminalモードからコマンドモードに変更
map('t', '<ESC>', '<C-\\><C-n>', silent)
-- }}}
