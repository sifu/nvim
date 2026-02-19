-- [nfnl] fnl/user/telescope-routes.fnl
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config")
local route_file = "/s/prj/frontend-demo/src/route-definitions.tsx"
local base_dir = "/s/prj/frontend-demo/src"
local function resolve_import_path(import_path)
  local normalized = import_path:gsub("^@/", ""):gsub("^%./", ""):gsub("/%./", "/")
  local full_base = (base_dir .. "/" .. normalized)
  local extensions = {".tsx", ".ts", ".jsx", ".js"}
  local result = nil
  for _, ext in ipairs(extensions) do
    if result then break end
    local path = (full_base .. ext)
    if (vim.fn.filereadable(path) == 1) then
      result = path
    else
    end
  end
  return result
end
local function parse_routes()
  local lines = vim.fn.readfile(route_file)
  local imports = {}
  local entries = {}
  local pending_lazy_name = nil
  local depth = 0
  local in_routes = false
  local path_at_depth = {}
  for _, line in ipairs(lines) do
    do
      local name, import_path = line:match("const%s+(%w+)%s*=%s*lazy%(%s*%(%)%s*=>%s*import%('([^']+)'%)")
      if (name and import_path) then
        imports[name] = import_path
      else
      end
    end
    if not pending_lazy_name then
      local name = line:match("^const%s+(%w+)%s*=%s*lazy%(")
      if (name and not line:match("import%(")) then
        pending_lazy_name = name
      else
      end
    else
    end
    if pending_lazy_name then
      local import_path = line:match("import%('([^']+)'%)")
      if import_path then
        imports[pending_lazy_name] = import_path
        pending_lazy_name = nil
      else
      end
    else
    end
    if line:match("routeDefinitions") then
      in_routes = true
    else
    end
    if in_routes then
      for char in line:gmatch("[{}]") do
        if (char == "{") then
          depth = (depth + 1)
        else
          path_at_depth[depth] = nil
          depth = (depth - 1)
        end
      end
      do
        local path_val = line:match("path:%s*'([^']+)'")
        if path_val then
          path_at_depth[depth] = path_val
        else
        end
      end
      for component in line:gmatch("<(%w+)") do
        if imports[component] then
          local segments = {}
          for d = 1, depth do
            local seg = path_at_depth[d]
            if (seg and (seg ~= "/")) then
              table.insert(segments, seg)
            else
            end
          end
          table.insert(entries, {full_path = ("/" .. table.concat(segments, "/")), component = component})
        else
        end
      end
    else
    end
  end
  return entries, imports
end
local function routes()
  if (vim.fn.filereadable(route_file) ~= 1) then
    vim.notify(("Route file not found: " .. route_file), vim.log.levels.ERROR)
    return
  else
  end
  local entries, imports = parse_routes()
  local results = {}
  for _, entry in ipairs(entries) do
    local import_path = imports[entry.component]
    local file_path = resolve_import_path(import_path)
    if file_path then
      table.insert(results, {display = (entry.full_path .. " <" .. entry.component .. " />"), file_path = file_path})
    else
    end
  end
  local picker
  local function _15_(item)
    return {value = item, display = item.display, ordinal = item.display, path = item.file_path}
  end
  picker = pickers.new({}, {prompt_title = "Routes", finder = finders.new_table({results = results, entry_maker = _15_}), sorter = conf.values.generic_sorter({}, "previewer", conf.values.file_previewer({}))})
  return picker:find()
end
return {routes = routes}
