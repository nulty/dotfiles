local on_attach = function(client, buf)
  local opts = { buffer = buf, noremap = true, silent = true }

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- LSP Mappings using modern vim.keymap.set
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>A', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-/>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>rf', '<Cmd>Telescope lsp_references<CR>', opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>d', function()
    vim.lsp.buf.format({
      async = true,
      filter = function(fn_client)
        return fn_client.name == "null-ls" or fn_client.name == "lua_ls"
      end
    })
  end, opts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec2([[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], {})
  end
end

vim.api.nvim_create_user_command("LspClearLog", function()
  local lsp_log_path = vim.lsp.get_log_path()
  local null_ls_log_path = require'null-ls.logger'.get_path()
  io.popen("truncate -s 0 " .. lsp_log_path)
  io.popen("truncate -s 0 " .. null_ls_log_path)
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
