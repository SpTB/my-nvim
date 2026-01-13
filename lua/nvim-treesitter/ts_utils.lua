-- Compatibility shim for plugins (e.g. Neorg) that still require:
--   require("nvim-treesitter.ts_utils")
-- when using nvim-treesitter "main" rewrite.
--
-- This is NOT a full reimplementation; it's "enough" for most plugins.
-- If you hit a missing function, tell me which one and I’ll extend it.

local M = {}

local function get_node_text_fn()
  -- Neovim versions differ: prefer vim.treesitter.get_node_text when present
  if type(vim.treesitter.get_node_text) == 'function' then
    return vim.treesitter.get_node_text
  end
  if vim.treesitter.query and type(vim.treesitter.query.get_node_text) == 'function' then
    return vim.treesitter.query.get_node_text
  end
  return nil
end

function M.get_node_text(node, bufnr)
  local fn = get_node_text_fn()
  if not fn or not node then
    return ''
  end
  return fn(node, bufnr or 0)
end

function M.get_node_at_cursor(winid)
  winid = winid or 0
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local pos = vim.api.nvim_win_get_cursor(winid)
  local row, col = pos[1] - 1, pos[2]

  -- Newer API
  if type(vim.treesitter.get_node) == 'function' then
    local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col } })
    if ok and node then
      return node
    end
  end

  -- Fallback: parse + descendant lookup
  local okp, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not okp or not parser then
    return nil
  end
  local trees = parser:parse()
  local tree = trees and trees[1]
  if not tree then
    return nil
  end
  local root = tree:root()
  if not root then
    return nil
  end
  return root:named_descendant_for_range(row, col, row, col)
end

function M.goto_node(node, _goto_end, winid)
  if not node then
    return
  end
  winid = winid or 0
  local row, col = node:start()
  vim.api.nvim_win_set_cursor(winid, { row + 1, col })
end

-- Simple depth-first "next node" traversal helpers (approximate old ts_utils behavior)
local function next_in_tree(node, named)
  if not node then
    return nil
  end

  -- First child
  local child = named and node:named_child(0) or node:child(0)
  if child then
    return child
  end

  -- Next sibling up the chain
  local cur = node
  while cur do
    local sib = named and cur:next_named_sibling() or cur:next_sibling()
    if sib then
      return sib
    end
    cur = cur:parent()
  end
  return nil
end

local function prev_in_tree(node, named)
  if not node then
    return nil
  end

  local cur = node
  local sib = named and cur:prev_named_sibling() or cur:prev_sibling()
  if sib then
    -- go to the deepest last child of that sibling
    local n = sib
    while true do
      local count = named and n:named_child_count() or n:child_count()
      if not count or count == 0 then
        break
      end
      n = named and n:named_child(count - 1) or n:child(count - 1)
      if not n then
        break
      end
    end
    return n or sib
  end
  return cur:parent()
end

-- Old signature-ish: get_next_node(node, recursive, named)
function M.get_next_node(node, recursive, named)
  if not node then
    return nil
  end
  if recursive == false then
    return named and node:next_named_sibling() or node:next_sibling()
  end
  return next_in_tree(node, named)
end

function M.get_previous_node(node, recursive, named)
  if not node then
    return nil
  end
  if recursive == false then
    return named and node:prev_named_sibling() or node:prev_sibling()
  end
  return prev_in_tree(node, named)
end

return M
