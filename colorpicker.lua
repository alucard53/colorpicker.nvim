local setColor = function(win, colors)
    return function()
        local cursor = vim.api.nvim_win_get_cursor(win)

        vim.cmd.colorscheme(colors[cursor[1]])

        local file = io.open('after/plugin/colors.lua', 'w')

        if file then
            file:write(string.format("vim.cmd.colorscheme(\"%s\")", colors[cursor[1]]))
            file:close()
        end
    end
end

ColorPicker = function()
    local ui = vim.api.nvim_list_uis()[1]

    local opts = {
        relative = 'editor',
        width = 30,
        height = 30,
        col = (ui.width / 2) - 15,
        row = (ui.height / 2) - 15,
        anchor = 'NW',
        style = 'minimal',
        border = 'rounded'
    }

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, 1, opts)


    local color_files = vim.api.nvim_get_runtime_file('colors/*.vim', true)
    local lua_color_files = vim.api.nvim_get_runtime_file('colors/*.lua', true)
    local colors = {}

    table.move(lua_color_files, 1, #lua_color_files, #color_files + 1, color_files)

    for _, v in ipairs(color_files) do
        local j = 0
        --if not string.match(v, 'share') then -- exclude default
        for i = string.len(v), 1, -1 do
            if string.char(v:byte(i)) == '\\' then
                j = i + 1
                goto continue
            end
        end
        ::continue::
        table.insert(colors, string.sub(v, j, string.len(v) - 4))
        --end
    end


    vim.api.nvim_buf_set_lines(buf, 0, table.getn(colors) + 1, false, colors)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-s>', '', { callback = setColor(win, colors) })
end

vim.keymap.set('n', '<C-c>', ColorPicker, {})
