local M = {}

local config = {
  enabled = true,
  minimum_width = 80,
  extra_width = 0,
  compute = true,
  bufname_additional_patterns = {}
}

local function max(list)
  local max_val = 0
  for _, val in ipairs(list) do
    if val > max_val then
      max_val = val
    end
  end
  return max_val
end

local function line_number_width()
  if not vim.wo.number then
    return 0
  end
  
  local numberwidth = vim.wo.numberwidth
  local smallest_width = string.len(tostring(vim.fn.line('$')))
  
  return max({smallest_width, numberwidth}) + 1
end

local function sign_width()
  local current_file = vim.fn.bufnr('%')
  
  if not vim.fn.bufexists(current_file) then
    return 0
  end
  
  local filename = vim.fn.bufname(current_file)
  if filename == '' or not vim.fn.filereadable(filename) then
    return 0
  end
  
  local signs = vim.fn.execute('sign place file=' .. filename)
  local sign_lines = vim.split(signs, '\n')
  
  if #sign_lines >= 3 then
    return 2
  end
  
  return 0
end

local function total_left_width()
  if not config.compute then
    return 0
  end
  
  return sign_width() + line_number_width()
end

local function current_width()
  return vim.fn.winwidth(0)
end

local function new_width()
  return config.minimum_width + total_left_width() + config.extra_width
end

local function nerd_tree_just_opened()
  if vim.t.NERDTreeBufName and vim.fn.bufwinnr(vim.t.NERDTreeBufName) == -1 then
    return true
  end
  
  return false
end

local function in_file_browser()
  if nerd_tree_just_opened() then
    return true
  end
  
  local patterns = {"NERD_tree", "vimpanel"}
  for _, pattern in ipairs(config.bufname_additional_patterns) do
    table.insert(patterns, pattern)
  end
  
  local bufname = vim.fn.bufname('%')
  for _, pattern in ipairs(patterns) do
    if string.match(bufname, pattern) then
      return true
    end
  end
  
  return false
end

function M.resize()
  if config.enabled and not in_file_browser() then
    local size = new_width()
    
    if size > current_width() then
      vim.cmd('silent vertical resize ' .. size)
    end
  end
end

function M.enable(enabled)
  config.enabled = enabled
end

function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend('force', config, opts)
  
  local group = vim.api.nvim_create_augroup('Eighties', { clear = true })
  vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter', 'BufWinEnter', 'BufWritePost'}, {
    group = group,
    callback = M.resize
  })
  
  vim.api.nvim_create_user_command('EightiesDisable', function() M.enable(false) end, {})
  vim.api.nvim_create_user_command('EightiesEnable', function() M.enable(true) end, {})
  vim.api.nvim_create_user_command('EightiesResize', M.resize, {})
end

return M