-- Compatibility shim for plugins (e.g. Neorg) that still do:
--   require("nvim-treesitter.parsers").get_parser_configs()
-- when using nvim-treesitter "main" rewrite.

local M = {}

-- Keep configs in a global so they're shared even if modules reload.
_G.__NVIM_TREESITTER_PARSER_CONFIGS = _G.__NVIM_TREESITTER_PARSER_CONFIGS or {}
local parser_configs = _G.__NVIM_TREESITTER_PARSER_CONFIGS

-- Old API: returns a mutable table that plugins add to (e.g. parser_configs.norg = {...})
function M.get_parser_configs()
  return parser_configs
end

-- Some plugins call these too (harmless to provide).
function M.get_parser_config(lang)
  return parser_configs[lang]
end

function M.set_parser_config(lang, cfg)
  parser_configs[lang] = cfg
end

return M
