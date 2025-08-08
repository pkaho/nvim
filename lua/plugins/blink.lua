local has_words_before = function ()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- 如果是行首直接返回false
    if col == 0 then
        return false
    end

    -- 获取当前行内容
    local line = vim.api.nvim_get_current_line()

    -- 检查是否是空白字符, %s匹配任何空白字符(空格, tab等)
    return line:sub(col, col):match("%s") == nil
end

return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
        keymap = {
            preset = "default",

            -- 使用tab/S-tab在补全菜单之间导航
            ["<Tab>"] = {
                function (cmp)
                    if has_words_before() then
                        return cmp.insert_next()
                    end
                end,
                "fallback",
            },
            ['<S-Tab>'] = { 'insert_prev' },
        },
    },
    opts_extend = { "sources.default" }
}
