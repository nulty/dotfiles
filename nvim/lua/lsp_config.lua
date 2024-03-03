local on_attach = function(client, buf)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(buf, ...) end
  local lua_opts = { noremap = true, silent = false, buffer = buf }

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
  -- buf_set_keymap('n', '<leader>rf', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>rf', '<Cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<Cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<Cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  vim.keymap.set('n', '<leader>d', function()
    vim.lsp.buf.format({
      async = true,
      filter = function(fn_client)
        return fn_client.name == "null-ls" or fn_client.name == "lua_ls" or fn_client.name == "solargraph"
      end
    })
  end, lua_opts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec2([[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]])
  end
end

vim.api.nvim_create_user_command("LspClearLog", function()
  local log_path = vim.lsp.get_log_path()
  io.popen("truncate -s 0 " .. log_path)
end, {})

local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

return {
  on_attach = on_attach,
  capabilities = capabilities
  --settings
  --filetypes
  --init_options
}
