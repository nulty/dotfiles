--------------------------------------------------------------------------
-- CONFIGURATION
--
-- Everything you are likely to want to change lives in this block. The
-- implementation is below the divider and shouldn't need editing to adjust
-- behaviour.
--
-- Commands:
--   :FormatInfo                     explain what <leader>d would run here
--   :FormatDebug                    toggle per-step logging
--   :FormatOnSave [tool] [setting]  control formatting on save
--------------------------------------------------------------------------

local config = {}

--- Which tools format on save, before any :FormatOnSave override.
--- Off by default: nothing rewrites a buffer behind you unless you ask.
--- Set one to true here to make it permanent.
config.format_on_save = {
  prettier = false,
  erb_lint = false,
  ruby_lsp = false,
  stylelint = false,
  herb_ls = false,
  lua_ls = false,
  eslint = false,
  ['null-ls'] = false,
}

--- Tools to run for a filetype, in order. Later entries format last, so they
--- win where two tools disagree.
config.chains = {
  lua = { 'lua_ls' },
  -- ruby-lsp's RuboCop addon does both diagnostics and formatting, using the
  -- rubocop the project bundles. Named explicitly so ruby does not fall through
  -- to the null-ls default chain, which has no ruby formatter.
  ruby = { 'ruby_lsp' },
  -- erb_lint rewrites the Ruby inside the tags; herb then normalises the
  -- markup around it. Naming both explicitly guarantees the order.
  eruby = { 'erb_lint', 'herb_ls' },
}

--- html is resolved from what the project has checked in, not the filetype.
config.html_chains = {
  prettier_config = { 'prettier' },
  herb_config = { 'herb_ls' },
  neither = { 'prettier', 'herb_ls' },
}

--- Used for any filetype without an entry in config.chains.
config.default_chain = { 'null-ls' }

--- Project markers that decide the html chain above.
config.prettier_markers = {
  '.prettierrc',
  '.prettierrc.json', '.prettierrc.json5',
  '.prettierrc.yml', '.prettierrc.yaml',
  '.prettierrc.js', '.prettierrc.cjs', '.prettierrc.mjs',
  '.prettierrc.toml',
  'prettier.config.js', 'prettier.config.cjs', 'prettier.config.mjs',
}
config.herb_markers = { '.herb.yml' }

--- Names that are none-ls sources rather than LSP clients. A step naming one
--- runs null-ls with only that source enabled, which is what makes ordering
--- between two none-ls tools possible.
config.null_ls_sources = {
  prettier = true,
  erb_lint = true,
  stylelint = true,
}

--- Tools that only ever run on save, never on <leader>d. eslint is here
--- because <leader>d already reaches it through none-ls; this entry is the
--- eslint *LSP client*, which formats on save when enabled.
config.save_only = {
  eslint = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
    'vue', 'svelte', 'astro' },
}

--------------------------------------------------------------------------
-- IMPLEMENTATION
--------------------------------------------------------------------------

local M = { config = config }

local debug_enabled = false
local session = {} --- tool -> bool, set by :FormatOnSave

local function log(msg)
  if debug_enabled then
    vim.notify('[format] ' .. msg, vim.log.levels.INFO)
  end
end

local function project_root(buf, markers)
  return vim.fs.root(buf, markers)
end

local function attached_names(buf)
  local names = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    names[#names + 1] = c.name
  end
  return names
end

local function client_named(buf, name)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if c.name == name then return c end
  end
end

--- Every tool this module knows how to talk about.
function M.known_tools()
  local names = {}
  for name in pairs(config.format_on_save) do names[#names + 1] = name end
  table.sort(names)
  return names
end

--- Tools to run for a buffer, plus why, so :FormatInfo can explain itself
--- without duplicating the decision.
function M.chain(buf)
  local ft = vim.bo[buf].filetype

  if config.chains[ft] then
    return config.chains[ft], 'filetype=' .. ft
  end

  if ft == 'html' then
    local root = project_root(buf, config.prettier_markers)
    if root then
      return config.html_chains.prettier_config, 'prettier config found under ' .. root
    end
    root = project_root(buf, config.herb_markers)
    if root then
      return config.html_chains.herb_config, '.herb.yml found under ' .. root
    end
    return config.html_chains.neither, 'filetype=html with no prettier or herb config'
  end

  return config.default_chain, 'default for filetype=' .. (ft == '' and '(none)' or ft)
end

--- none-ls formatting sources registered for this buffer's filetype.
--- Conditional sources (erb_lint) only appear when their condition passed.
local function null_ls_formatters(buf)
  local ok, sources = pcall(require, 'null-ls.sources')
  if not ok then return nil end
  local names = {}
  for _, source in ipairs(sources.get_available(vim.bo[buf].filetype, 'NULL_LS_FORMATTING')) do
    names[#names + 1] = source.name
  end
  table.sort(names)
  return names
end

--- null-ls fronts many tools, so name them where the step is the bare client.
function M.label(buf, tool)
  if tool ~= 'null-ls' then return tool end
  local names = null_ls_formatters(buf)
  if not names then return 'null-ls (sources unknown)' end
  if #names == 0 then return 'null-ls (no formatting sources for this filetype)' end
  return 'null-ls (' .. table.concat(names, ', ') .. ')'
end

--- Is this step able to do anything in this buffer right now?
function M.step_status(buf, tool)
  if config.null_ls_sources[tool] then
    local names = null_ls_formatters(buf) or {}
    for _, n in ipairs(names) do
      if n == tool then return true, 'registered with null-ls' end
    end
    return false, 'not registered with null-ls for this filetype'
  end

  local client = client_named(buf, tool)
  if not client then return false, 'client not attached' end
  if not client.server_capabilities.documentFormattingProvider then
    return false, 'attached but cannot format'
  end
  return true, 'attached, can format'
end

--- Format with null-ls but only through `source_name`, by disabling its
--- siblings for the duration. Restored in all cases, including on error.
local function format_via_source(buf, source_name)
  local ok, null_ls = pcall(require, 'null-ls')
  local ok_src, sources = pcall(require, 'null-ls.sources')
  if not (ok and ok_src) then return end

  local siblings = {}
  for _, source in ipairs(sources.get_available(vim.bo[buf].filetype, 'NULL_LS_FORMATTING')) do
    if source.name ~= source_name then
      siblings[#siblings + 1] = { name = source.name, was_disabled = source._disabled }
    end
  end

  for _, s in ipairs(siblings) do
    if not s.was_disabled then null_ls.disable({ name = s.name }) end
  end

  local done, err = pcall(vim.lsp.buf.format, {
    bufnr = buf,
    async = false,
    filter = function(client) return client.name == 'null-ls' end,
  })

  for _, s in ipairs(siblings) do
    if not s.was_disabled then null_ls.enable({ name = s.name }) end
  end

  if not done then error(err) end
end

local function run_step(buf, tool)
  if config.null_ls_sources[tool] then
    format_via_source(buf, tool)
  else
    vim.lsp.buf.format({
      bufnr = buf,
      async = false,
      filter = function(client) return client.name == tool end,
    })
  end
end

--- Precedence: buffer-local > session (:FormatOnSave) > config.format_on_save.
function M.on_save_enabled(buf, tool)
  local buf_map = vim.b[buf].format_on_save
  if type(buf_map) == 'table' and buf_map[tool] ~= nil then return buf_map[tool] end
  if session[tool] ~= nil then return session[tool] end
  return config.format_on_save[tool] == true
end

function M.on_save_source(buf, tool)
  local buf_map = vim.b[buf].format_on_save
  if type(buf_map) == 'table' and buf_map[tool] ~= nil then return 'buffer-local' end
  if session[tool] ~= nil then return 'session (:FormatOnSave)' end
  return 'default'
end

--- Tools that run on save for this buffer: the chain plus any save_only tool
--- whose filetype matches, each gated on its own on-save setting.
function M.save_chain(buf)
  local ft = vim.bo[buf].filetype
  local chain = M.chain(buf)
  local out = {}

  for _, tool in ipairs(chain) do
    if M.on_save_enabled(buf, tool) then out[#out + 1] = tool end
  end

  for tool, filetypes in pairs(config.save_only) do
    if vim.tbl_contains(filetypes, ft) and M.on_save_enabled(buf, tool) then
      out[#out + 1] = tool
    end
  end

  return out
end

--- Run each tool in turn. Separate synchronous calls rather than one filtered
--- call, because a single format() visits clients in get_clients() order,
--- which would make the sequence non-deterministic.
function M.run(buf, tools, trigger)
  buf = buf or vim.api.nvim_get_current_buf()

  if debug_enabled then
    log(('--- %s on %s (ft=%s)'):format(
      trigger or 'format',
      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.'),
      vim.bo[buf].filetype))
    local labelled = {}
    for _, t in ipairs(tools) do labelled[#labelled + 1] = M.label(buf, t) end
    log('chain:  ' .. (#tools > 0 and table.concat(labelled, ' -> ') or '(nothing to run)'))
    log('attached: ' .. (#attached_names(buf) > 0 and table.concat(attached_names(buf), ', ') or 'NONE'))
  end

  for i, tool in ipairs(tools) do
    local ready, why = M.step_status(buf, tool)
    local before = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')

    -- Skip rather than call format() with no matching client: nvim emits
    -- "Format request failed, no matching language servers" otherwise.
    if ready then run_step(buf, tool) end

    if debug_enabled then
      local after = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
      log(('  %d/%d %s -- %s, %s'):format(
        i, #tools, M.label(buf, tool), why,
        ready and (before ~= after and 'CHANGED buffer' or 'no change') or 'skipped'))
    end
  end
end

--- <leader>d: the full chain, regardless of any on-save setting.
function M.format(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  M.run(buf, M.chain(buf), '<leader>d')
end

--- BufWritePre: only the tools enabled for save.
function M.format_on_save(buf)
  local tools = M.save_chain(buf)
  if #tools == 0 then return end
  M.run(buf, tools, 'BufWritePre')
end

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = true }),
  callback = function(args) M.format_on_save(args.buf) end,
})

--------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------

vim.api.nvim_create_user_command('FormatInfo', function()
  local buf = vim.api.nvim_get_current_buf()
  local chain, reason = M.chain(buf)
  local lines = {
    'file:      ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.'),
    'filetype:  ' .. vim.bo[buf].filetype,
    'reason:    ' .. reason,
    'chain:     ' .. table.concat(chain, ' -> '),
    'attached:  ' .. (#attached_names(buf) > 0 and table.concat(attached_names(buf), ', ') or 'NONE'),
    '',
    'markers found:',
    '  prettier: ' .. tostring(project_root(buf, config.prettier_markers) or 'none'),
    '  herb:     ' .. tostring(project_root(buf, config.herb_markers) or 'none'),
    '',
    '<leader>d would run:',
  }
  for i, tool in ipairs(chain) do
    local _, why = M.step_status(buf, tool)
    lines[#lines + 1] = ('  %d. %s -- %s'):format(i, M.label(buf, tool), why)
  end

  local save_tools = M.save_chain(buf)
  lines[#lines + 1] = ''
  lines[#lines + 1] = 'on save would run:'
  if #save_tools == 0 then
    lines[#lines + 1] = '  (nothing -- see :FormatOnSave)'
  end
  for i, tool in ipairs(save_tools) do
    lines[#lines + 1] = ('  %d. %s (%s)'):format(i, M.label(buf, tool), M.on_save_source(buf, tool))
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, { desc = 'Explain which formatters would run in this buffer' })

vim.api.nvim_create_user_command('FormatDebug', function()
  debug_enabled = not debug_enabled
  vim.notify('format debug ' .. (debug_enabled and 'ON' or 'OFF'), vim.log.levels.INFO)
end, { desc = 'Toggle verbose formatter logging' })

--- :FormatOnSave [tool] [setting]
--- setting: on | off | toggle | buffer | default | status  (default: toggle)
--- tool omitted means every tool.
vim.api.nvim_create_user_command('FormatOnSave', function(o)
  local buf = vim.api.nvim_get_current_buf()
  local settings = { on = true, off = true, toggle = true, buffer = true, default = true, status = true }
  local args = o.fargs
  local tool, setting

  if #args == 0 then
    setting = 'status'
  elseif #args == 1 then
    if settings[args[1]] then setting = args[1] else tool, setting = args[1], 'toggle' end
  else
    tool, setting = args[1], args[2]
  end

  if not settings[setting] then
    vim.notify('FormatOnSave: unknown setting ' .. setting
      .. ' (on|off|toggle|buffer|default|status)', vim.log.levels.ERROR)
    return
  end
  if tool and config.format_on_save[tool] == nil then
    vim.notify('FormatOnSave: unknown tool ' .. tool
      .. ' (' .. table.concat(M.known_tools(), ', ') .. ')', vim.log.levels.ERROR)
    return
  end

  local targets = tool and { tool } or M.known_tools()

  for _, t in ipairs(targets) do
    if setting == 'on' or setting == 'off' then
      session[t] = (setting == 'on')
      local map = vim.b[buf].format_on_save
      if type(map) == 'table' then map[t] = nil; vim.b[buf].format_on_save = map end
    elseif setting == 'toggle' then
      session[t] = not M.on_save_enabled(buf, t)
      local map = vim.b[buf].format_on_save
      if type(map) == 'table' then map[t] = nil; vim.b[buf].format_on_save = map end
    elseif setting == 'buffer' then
      local map = vim.b[buf].format_on_save
      if type(map) ~= 'table' then map = {} end
      map[t] = not M.on_save_enabled(buf, t)
      vim.b[buf].format_on_save = map
    elseif setting == 'default' then
      session[t] = nil
      local map = vim.b[buf].format_on_save
      if type(map) == 'table' then map[t] = nil; vim.b[buf].format_on_save = map end
    end
  end

  local lines = { 'format on save (ft=' .. vim.bo[buf].filetype .. '):' }
  for _, t in ipairs(targets) do
    lines[#lines + 1] = ('  %-10s %-3s (%s)'):format(
      t, M.on_save_enabled(buf, t) and 'ON' or 'off', M.on_save_source(buf, t))
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, {
  nargs = '*',
  complete = function(lead, line)
    local n = #vim.split(vim.trim(line), '%s+')
    local opts = (n > 2 or (n == 2 and line:sub(-1) == ' '))
      and { 'on', 'off', 'toggle', 'buffer', 'default', 'status' }
      or vim.list_extend(M.known_tools(), { 'on', 'off', 'toggle', 'buffer', 'default', 'status' })
    return vim.tbl_filter(function(v) return v:find(lead, 1, true) == 1 end, opts)
  end,
  desc = 'Control formatting on save per tool',
})

return M
