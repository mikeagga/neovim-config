return {
	cmd = { "R", "--slave", "-e", "languageserver::run()" },
	filetypes = { "r", "rmd", "quarto" },
	-- This specific root_markers list is what fixes the "Not Attaching" issue
	-- It allows the server to start even if there is no .git folder
	root_markers = { ".git", ".Rproj", "DESCRIPTION", "." },
	on_attach = function(client, bufnr)
		-- Disable completion/hover so it doesn't fight with R.nvim
		client.server_capabilities.completionProvider = false
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.signatureHelpProvider = false
	end,
}
