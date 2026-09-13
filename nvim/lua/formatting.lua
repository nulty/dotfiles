--------------------------------------------------------------------------
-- CONFIGURATION
--
-- Everything you are likely to want to change lives in this block. The
-- implementation is below the divider and shouldn't need editing to adjust
-- behaviour.
--
-- Commands:
--   :FormatInfo                     explain what <leader>d would run here
--   :FormatDebug                    toggle conform's debug logging
--   :FormatOnSave [tool] [setting]  control formatting on save
--   :ConformInfo                    conform's own view: log file, availability
--------------------------------------------------------------------------

local config = {}

--- Which tools format on save, before any :FormatOnSave override.
--- Off by default: nothing rewrites a buffer behind you unless you ask.
--- Set one to true here to make it permanent.
---
--- Names are conform formatter names for CLI tools and LSP client names for
--- servers; both appear in config.chains the same way.
config.format_on_save = {
  prettier = false,
  erb_lint = false,
  stylelint = false,
  black = false,
  jq = false,
  eslint = false,
  lua_ls = false,
  ruby_lsp = false,
  herb_ls = false,
}

--- Project markers that decide the html chain below.
config.prettier_markers = {
  '.prettierrc',
  '.prettierrc.json', '.prettierrc.json5',
  '.prettierrc.yml', '.prettierrc.yaml',
  '.prettierrc.js', '.prettierrc.cjs', '.prettierrc.mjs',
  '.prettierrc.toml',
  'prettier.config.js', 'prettier.config.cjs', 'prettier.config.mjs',
}
config.herb_markers = { '.herb.yml' }

--- Tools to run for a filetype, in order. Later entries format last, so they
--- win where two tools disagree.
---
--- This table is handed to conform as `formatters_by_ft`, so it uses conform's
--- shape rather than a private one: the array part lists CLI formatters, and
--- an LSP server joins the chain via `name` (which client) plus `lsp_format`
--- (where in the order it runs):
---
---   'prefer' — the server formats and no CLI tool runs
---   'first'  — the server formats, then the CLI tools
---   'last'   — the CLI tools format, then the server
---
--- conform allows one server per filetype, which is all any chain here needs.
--- A value may also be a function(bufnr) returning such a table, which is how
--- html decides between prettier and herb per project.
config.chains = {
  lua = { lsp_format = 'prefer', name = 'lua_ls' },

  -- ruby-lsp's RuboCop addon does both diagnostics and formatting, using the
  -- rubocop the project bundles.
  ruby = { lsp_format = 'prefer', name = 'ruby_lsp' },

  -- erb_lint rewrites the Ruby inside the tags; herb then normalises the
  -- markup around it.
  eruby = { 'erb_lint', lsp_format = 'last', name = 'herb_ls' },

  python = { 'black' },

  -- jq normalises the structure, prettier then applies the project's style.
  json = { 'jq', 'prettier' },

  css = { 'prettier', 'stylelint' },
  scss = { 'prettier', 'stylelint' },
  less = { 'prettier', 'stylelint' },
  sass = { 'stylelint' },

  --- html is resolved from what the project has checked in, not the filetype.
  html = function(buf)
    if vim.fs.root(buf, config.prettier_markers) then
      return { 'prettier' }
    end
    if vim.fs.root(buf, config.herb_markers) then
      return { lsp_format = 'prefer', name = 'herb_ls' }
    end
    return { 'prettier', lsp_format = 'last', name = 'herb_ls' }
  end,
}

--- prettier on its own, for the filetypes it handles and nothing else does.
for _, ft in ipairs({
  'json5', 'jsonc', 'yaml', 'markdown', 'markdown.mdx',
  'graphql', 'handlebars', 'htmlangular',
}) do
  config.chains[ft] = { 'prettier' }
end

--- prettier for layout, then eslint's own LSP client for its fixable rules.
--- The eslint server resolves the project's flat config itself, so there is no
--- hardcoded `-c eslint.config.js` any more.
for _, ft in ipairs({
  'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
  'vue', 'svelte', 'astro',
}) do
  config.chains[ft] = { 'prettier', lsp_format = 'last', name = 'eslint' }
end

--- Custom formatters, and overrides for the ones conform ships.
config.formatters = {
  prettier = {
    prepend_args = {
      '--html-whitespace-sensitivity', 'ignore',
      '--prose-wrap', 'always',
    },
  },

  -- conform has no erb_lint builtin (its `erb_format` is the unrelated
  -- erb-formatter gem), so this is the whole definition.
  --
  -- stdin = false because `erb_lint --autocorrect FILE` rewrites the file in
  -- place: conform writes the buffer to a temp file, runs this, and reads the
  -- temp file back. That also sidesteps the `--stdin` mode's banner, where the
  -- corrected source is preceded by a "===== path =====" header that the
  -- caller has to strip.
  --
  -- exit_codes includes 1: erb_lint exits non-zero when offences remain that
  -- it cannot correct, having still corrected the ones it can.
  erb_lint = {
    meta = {
      url = 'https://github.com/Shopify/erb-lint',
      description = 'Lint and autocorrect the Ruby inside ERB tags',
    },
    command = 'erb_lint',
    args = { '--autocorrect', '$FILENAME' },
    stdin = false,
    exit_codes = { 0, 1 },
    -- Opt-in per project, as before: no config file, no erb_lint. require_cwd
    -- turns the missing root into "unavailable", which :FormatInfo reports and
    -- <leader>d skips, rather than a failure.
    cwd = function(_, ctx)
      return vim.fs.root(ctx.buf, { '.erb-lint.yml', '.erb_lint.yml' })
    end,
    require_cwd = true,
  },
}

--- Ceiling for a synchronous format, in milliseconds. Not a delay: it returns
--- as soon as the tools do. Only applies when config.async is false.
---
--- Measured on this machine: erb_lint 1603ms (it boots Ruby), stylelint 705ms,
--- eslint 456ms, prettier ~370ms.
config.timeout_ms = 3000

--- Run <leader>d asynchronously. The editor stays responsive while a slow tool
--- (erb_lint, ~1.6s) works, and conform applies the edits when it finishes.
--- The trade-off: if the buffer changes before then, conform discards the
--- result rather than clobbering what you typed. Set false for the old
--- blocking behaviour, where config.timeout_ms is the ceiling instead.
config.async = true

--- Formatting on save is always synchronous, so the file written matches the
--- buffer. A slow tool blocks the write for as long as it takes.
config.save_timeout_ms = 3000

--------------------------------------------------------------------------
-- IMPLEMENTATION
--------------------------------------------------------------------------

local M = { config = config }

local session = {} --- tool -> bool, set by :FormatOnSave

--- The chain for a buffer, plus why, so :FormatInfo can explain itself without
--- duplicating the decision. Returns conform's own entry shape.
function M.chain(buf)
  local ft = vim.bo[buf].filetype
  local entry = config.chains[ft]

  if type(entry) == 'function' then
    local resolved = entry(buf)
    local why = 'filetype=' .. ft
    if vim.fs.root(buf, config.prettier_markers) then
      why = why .. ', prettier config found'
    elseif vim.fs.root(buf, config.herb_markers) then
      why = why .. ', .herb.yml found'
    else
      why = why .. ', no prettier or herb config'
    end
    return resolved, why
  end

  if entry then return entry, 'filetype=' .. ft end
  return {}, 'no chain for filetype=' .. (ft == '' and '(none)' or ft)
end

--- Does this entry put an LSP server in the chain?
local function entry_lsp(entry)
  if entry.name and entry.lsp_format and entry.lsp_format ~= 'never' then
    return entry.name
  end
end

--- Every tool in an entry, in the order they run.
function M.steps(entry)
  local out = {}
  local lsp = entry_lsp(entry)
  if lsp and entry.lsp_format == 'first' then out[#out + 1] = lsp end
  for _, name in ipairs(entry) do out[#out + 1] = name end
  if lsp and entry.lsp_format ~= 'first' then out[#out + 1] = lsp end
  return out
end

--- Is this step able to do anything in this buffer right now?
function M.step_status(buf, entry, tool)
  if tool == entry_lsp(entry) then
    local clients = require('conform.lsp_format').get_format_clients({ bufnr = buf, name = tool })
    if vim.tbl_isempty(clients) then return false, 'client not attached, or cannot format' end
    return true, 'attached, can format'
  end

  local info = require('conform').get_formatter_info(tool, buf)
  if info.error then return false, 'formatter config is broken' end
  if not info.available then return false, info.available_msg or 'unavailable' end
  return true, 'available: ' .. info.command
end

--- Turn a chain entry into arguments for conform.format.
local function format_opts(buf, entry)
  return {
    bufnr = buf,
    formatters = vim.list_slice(entry),
    lsp_format = entry.lsp_format,
    name = entry.name,
    id = entry.id,
    filter = entry.filter,
  }
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

--- Every tool this module knows how to talk about.
function M.known_tools()
  local names = {}
  for name in pairs(config.format_on_save) do names[#names + 1] = name end
  table.sort(names)
  return names
end

--- The chain with every tool that is off for save removed. nil when that
--- leaves nothing, which is what conform's format_on_save wants in order to
--- skip the buffer entirely.
function M.save_chain(buf)
  local entry = M.chain(buf)
  local lsp = entry_lsp(entry)
  local keep_lsp = lsp ~= nil and M.on_save_enabled(buf, lsp)

  local out = { name = entry.name, id = entry.id, filter = entry.filter }
  for _, name in ipairs(entry) do
    if M.on_save_enabled(buf, name) then out[#out + 1] = name end
  end

  if #out == 0 and not keep_lsp then return nil end

  -- 'never' rather than dropping `name`: with an empty formatter list conform
  -- runs the LSP for any setting but 'never', which is the opposite of what a
  -- disabled server should do.
  out.lsp_format = keep_lsp and entry.lsp_format or 'never'
  return out
end

--- <leader>d: the full chain, regardless of any on-save setting.
function M.format(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local entry = M.chain(buf)
  local opts = format_opts(buf, entry)
  opts.async = config.async
  opts.timeout_ms = config.timeout_ms
  require('conform').format(opts, function(err)
    if err then
      vim.notify('format: ' .. err .. ' (see :ConformInfo)', vim.log.levels.WARN)
    end
  end)
end

--- Handed to conform's own format_on_save, which owns the BufWritePre autocmd.
function M.on_save_opts(buf)
  local entry = M.save_chain(buf)
  if not entry then return nil end
  local opts = format_opts(buf, entry)
  opts.timeout_ms = config.save_timeout_ms
  return opts
end

--- The full setup table for conform. Kept here so the configuration block
--- above stays the one place behaviour is described.
function M.conform_opts()
  return {
    formatters_by_ft = config.chains,
    formatters = config.formatters,
    default_format_opts = { timeout_ms = config.timeout_ms },
    format_on_save = function(buf) return M.on_save_opts(buf) end,
    -- A tool that fails now says so instead of leaving the buffer unchanged.
    notify_on_error = true,
    -- ... but a filetype with no chain at all is normal, not a problem.
    notify_no_formatters = false,
    log_level = vim.log.levels.WARN,
  }
end

--------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------

vim.api.nvim_create_user_command('FormatInfo', function()
  local buf = vim.api.nvim_get_current_buf()
  local entry, reason = M.chain(buf)
  local steps = M.steps(entry)
  local clients = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do clients[#clients + 1] = c.name end

  local lines = {
    'file:      ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.'),
    'filetype:  ' .. vim.bo[buf].filetype,
    'reason:    ' .. reason,
    'chain:     ' .. (#steps > 0 and table.concat(steps, ' -> ') or '(nothing)'),
    'attached:  ' .. (#clients > 0 and table.concat(clients, ', ') or 'NONE'),
    'mode:      ' .. (config.async and 'async' or 'blocking, ' .. config.timeout_ms .. 'ms ceiling'),
    '',
    '<leader>d would run:',
  }
  if #steps == 0 then
    lines[#lines + 1] = '  (nothing -- no chain for this filetype)'
  end
  for i, tool in ipairs(steps) do
    local _, why = M.step_status(buf, entry, tool)
    lines[#lines + 1] = ('  %d. %s -- %s'):format(i, tool, why)
  end

  local save_entry = M.save_chain(buf)
  local save_steps = save_entry and M.steps(save_entry) or {}
  lines[#lines + 1] = ''
  lines[#lines + 1] = 'on save would run:'
  if #save_steps == 0 then
    lines[#lines + 1] = '  (nothing -- see :FormatOnSave)'
  end
  for i, tool in ipairs(save_steps) do
    lines[#lines + 1] = ('  %d. %s (%s)'):format(i, tool, M.on_save_source(buf, tool))
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, { desc = 'Explain which formatters would run in this buffer' })

--- conform logs every run to a file; this only changes how much it writes.
--- :ConformInfo opens the log.
vim.api.nvim_create_user_command('FormatDebug', function()
  local log = require('conform.log')
  local on = log.level ~= vim.log.levels.DEBUG
  log.level = on and vim.log.levels.DEBUG or vim.log.levels.WARN
  vim.notify('format debug ' .. (on and 'ON' or 'OFF') .. ' -- :ConformInfo to read the log',
    vim.log.levels.INFO)
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
