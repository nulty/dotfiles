local formatting = require('formatting')

-- Keymaps are applied from an LspAttach autocmd rather than an on_attach in
-- vim.lsp.config('*', ...): a server-level on_attach replaces the shared one
-- instead of chaining, and nvim-lspconfig ships its own for eslint,
-- stylelint_lsp and ~24 others. LspAttach fires for every client regardless.
local function on_attach(client, buf)
  local opts = { buffer = buf, noremap = true, silent = true }

  vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- LSP Mappings using modern vim.keymap.set
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
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
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>d', function()
    formatting.format(buf)
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

-- Nvim 0.12 ships a builtin `:lsp` command, and nvim-lspconfig's plugin file
-- bails out entirely when it sees one -- taking :LspLog and :LspInfo with it.
-- The builtin has no equivalent of either, so re-create them ourselves.
vim.api.nvim_create_user_command("LspInfo", ':checkhealth vim.lsp',
  { desc = 'Alias to `:checkhealth vim.lsp`' })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd('tabnew ' .. vim.fn.fnameescape(vim.lsp.log.get_filename()))
end, { desc = 'Opens the Nvim LSP client log.' })

vim.api.nvim_create_user_command("LspClearLog", function()
  local paths = { vim.lsp.get_log_path() }
  for _, mod in ipairs({ 'null-ls.logger', 'conform.log' }) do
    local ok, logger = pcall(require, mod)
    if ok then paths[#paths + 1] = logger.get_path and logger.get_path() or logger.get_logfile() end
  end
  for _, path in ipairs(paths) do
    io.popen("truncate -s 0 " .. vim.fn.shellescape(path))
  end
end, {})

local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_keymaps', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})

return {
  capabilities = capabilities
  --settings
  --filetypes
  --init_options
}
