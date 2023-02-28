local M = {}

require('vim.lsp.log').set_level("debug")

local on_attach = function(client, buf)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(buf, ...) end

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Mappings.
	local opts = { noremap = true, silent = false }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<leader>A', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-/>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>rf', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<leader>e', '<Cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>q', '<Cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
	if client.name == "pyright" then
		buf_set_keymap('n', '<leader>d', '<cmd>:Black<CR>', opts)
		-- elseif client.name == "tailwindcss-language-server" then
		--     buf_set_keymap('n', '<leader>d', '<cmd>!prettier -w %<CR>', opts)
	else
		buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec([[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], false)
	end
end

local capabilities = function()
	local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
	--vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
	--updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

	--updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

	return updated_capabilities
end

function M.setup_event()
	--- print(vim.inspect("onattach called"))
	-- vim.api.nvim_create_autocmd("LspAttach", {
	-- 	callback = function(args)
	-- 		local buffer = args.buf
	--     local client = vim.lsp.get_client_by_id(args.data.client_id)

	-- 		print(vim.inspect("onattach called", args))

	-- 	end
	-- })

	return {
		on_attach = on_attach,
		--capabilities = capabilities,
		--capabilities = vim.lsp.protocol.make_client_capabilities(),
		capabilities = require'lspconfig'.util.default_config.capabilities,
		settings = {}
	}
end

return M
