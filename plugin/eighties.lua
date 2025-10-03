if vim.g.loaded_eighties then
    return
end
vim.g.loaded_eighties = true

require('eighties').setup()
