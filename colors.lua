local paths = vim.api.nvim_list_runtime_paths()
local optsPath = string.format('%s\\plugin\\coloroptions.txt', paths[#paths])
local file = io.open(optsPath, 'r')
local opts = {}
if file then
    for i in file:lines() do
        table.insert(opts, i)
    end
    file:close()
end

if #opts == 2 then
    vim.cmd.colorscheme(opts[1])
    if opts[2] == 'en' then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
    end
end
