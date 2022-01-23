local rust_settings = {
  ["rust-analyzer"] = {
    assist = {
      importGranularity = "module",
      importPrefix = "by_self",
    }
  },
  cargo = {
    loadOutDirsFromCheck = true
  },
  procMacro = {
    enable = true
  }
}
return rust_settings
