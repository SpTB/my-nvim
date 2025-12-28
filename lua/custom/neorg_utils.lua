-- lua/custom/neorg_utils.lua

local M = {}

--- Extracts list items marked with a specific tag from a neorg file.
--- @param file_path string The path to the neorg file.
--- @param tag string The tag to search for (e.g., 'important').
--- @return table A table of strings, where each string is a list item line.
function M.extract_tagged_list_items(file_path, tag)
  local results = {}
  local file = io.open(file_path, "r")
  if not file then
    print("Error: Could not open file: " .. file_path)
    return results
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local tag_map = {
    ambiguous = "%(%?%)",
    undone = "%( %)",
    recurring = "%(%+%)",
    pending = "%(%-%)",
    cancelled = "%(%_%)",
    done = "%(%x%)",
    ['on hold'] = "%(%=%)",
    important = "%(%!%)",
  }

  local tag_pattern = tag_map[tag:lower()]

  if not tag_pattern then
    print("Error: Tag '" .. tag .. "' is not supported.")
    return results
  end

  for _, line in ipairs(lines) do
    -- Check if the line is a list item and contains the tag pattern
    if string.match(line, "^%s*[-*]%s.*" .. tag_pattern) then
      table.insert(results, line)
    end
  end

  return results
end

return M
