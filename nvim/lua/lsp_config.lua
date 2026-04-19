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
        if fn_client.name == "lua_ls" then return true end

        -- For ERB: erb_lint (via null-ls) only registers when .erb-lint.yml
        -- exists in the project root, in which case it wins over herb_ls.
        if vim.bo.filetype == "eruby" then
          local ok, sources = pcall(require, "null-ls.sources")
          if ok then
            local methods = require("null-ls.methods")
            local available = sources.get_available("eruby", methods.internal.FORMATTING)
            if #available > 0 then
              return fn_client.name == "null-ls"
            end
          end
          return fn_client.name == "herb_ls"
        end

        return fn_client.name == "null-ls"
      end
    })
  end, opts)

  -- Document highlighting: highlights all occurrences of symbol under cursor after CursorHold,
  -- clears highlighting on cursor movement. Only enabled if LSP server supports it.
  -- CursorHold is run when the cursor doesn't move for a short time
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. buf, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buf,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buf,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
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
