vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])

vim.o.relativenumber = true
vim.o.number = true

vim.o.wrap = false
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.showtabline = 2

vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false

vim.o.termguicolors = true
vim.o.winborder = "rounded"

vim.o.undofile = true


vim.g.mapleader = " "

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "tex", "text" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en_us"
		vim.opt_local.textwidth = 80
	end,
})

vim.pack.add({
	{ src = "https://github.com/rockerBOO/boo-colorscheme-nvim" },
	{ src = "https://github.com/p00f/alabaster.nvim" },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter',        build = ':TSUpdate',             version = 'main' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp",                       version = vim.version.range("*") },
	{ src = "https://github.com/ribru17/blink-cmp-spell" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/quarto-dev/quarto-nvim" },
	{ src = "https://github.com/jmbuhr/otter.nvim" },
	{ src = "https://github.com/R-nvim/R.nvim" },
})

vim.lsp.config('marksman', {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "quarto" },
	root_markers = { ".marksman.toml", ".git" },
})

vim.lsp.enable({ "lua_ls", "pyright", "marksman", "r-languageserver" })

vim.cmd(":hi statusline guibg=NONE")

require "mason".setup()

require "otter"
require "quarto".setup()
require "r".setup()


require("blink.cmp").setup({
	signature = {
		enabled = true
	},
	completion = {
		keyword = { range = 'full' },
		documentation = {
			window = {
				border = "rounded",
			},
			auto_show = true,
			auto_show_delay_ms = 500,
		},
		menu = {
			border = "rounded",
			auto_show = true,
		},
	},
	sources = {
		default = { "lsp", "path", "spell", "buffer" },
		providers = {
			spell = {
				name = 'Spell',
				module = 'blink-cmp-spell',
			},
		},
	},
	fuzzy = {
		sorts = {
			function(a, b)
				local sort = require('blink.cmp.fuzzy.sort')
				if a.source_id == 'spell' and b.source_id == 'spell' then
					return sort.label(a, b)
				end
			end,
			'score',
			'kind',
			'label',
		},
	},
})

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
		skip_confirm_for_simple_edits = true,
	},
	columns = {
		"permissions",
		"size",
	},
})

vim.keymap.set("n", "<leader>e", ":Oil<Cr>")

local telescope = require("telescope")
local default_color = "alabaster"

telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		path_displays = { "smart" },
		layout_config = {
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")


require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}

local map = vim.keymap.set
local builtin = require("telescope.builtin")

map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope find files" })
function git_files() builtin.find_files({ no_ignore = true }) end

function grep() builtin.live_grep() end

for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")

map({ "n" }, "<leader>g", grep, { desc = "Telescope grep" })
map({ "n" }, "<leader>sg", git_files, { desc = "Telescope git files" })
map({ "n" }, "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Telescope string grep" })
map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Telescope old files" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Telescope reference" })
map({ "n" }, "<leader>sd", builtin.diagnostics, { desc = "Telescope diagnostics" })
map({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })
map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope pickers" })
map({ "n" }, "<leader>sc", builtin.git_bcommits, { desc = "Telescope buffer git commits" })
map({ "n" }, "<leader>sk", builtin.keymaps, { desc = "Telescope keymaps" })

map({ "n" }, "<leader>sa", require("actions-preview").code_actions, { desc = "LSP action preview" })
map({ "n" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP format" })

map({ "n", "i" }, "<M-i>", function()
	local cmp = require("blink.cmp")
	if cmp.is_visible() then
		cmp.hide()
	else
		cmp.show()
	end
end, { desc = "Toggle completion" })

vim.cmd('colorscheme ' .. default_color)
