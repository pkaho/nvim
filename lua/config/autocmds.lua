local function augroup(name)
    return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- 重新打开文件时恢复上次光标位置
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = augroup("goto_last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" } -- 排除的文件类型列表（例如 Git 提交信息）
        local buf = event.buf -- 获取当前缓冲区的 ID

        -- 如果当前文件类型在排除列表，或者已经处理过，则直接返回
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].custom_last_loc then
            return
        end

        vim.b[buf].custom_last_loc = true -- 标记该缓冲区已处理（避免重复执行）
        local mark = vim.api.nvim_buf_get_mark(buf, '"') -- 获取最后位置标记
        local lcount = vim.api.nvim_buf_line_count(buf) -- 获取当前缓冲区的总行数

        -- 如果标记位置有效（在文件范围内），则跳转到该位置
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark) -- 安全跳转（避免出错）
        end
    end,
})

-- 高亮复制内容
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = augroup("highlight_yank"),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- 禁用换行自动添加注释
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
    group = augroup("format_options"),
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- 每次保存文件前删除空行中的空格
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    group = augroup("clear_white_space"),
    callback = function()
        if vim.b.preserve_blank_spaces then
            return
        end

        local buf = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

        local in_ignore_block = false
        for i = 1, #lines do
            local text = lines[i]

            -- 块标记开始：whitespace:ignore start
            if text:match("^%s*%-%-%s*whitespace:%s*ignore%s*start") then
                in_ignore_block = true
                goto continue
            end
            -- 块标记结束：whitespace:ignore end
            if text:match("^%s*%-%-%s*whitespace:%s*ignore%s*end") then
                in_ignore_block = false
                goto continue
            end
            -- 是否处于块内
            if in_ignore_block then
                goto continue
            end

            -- 单行判断
            if text:match("%-%-%s*whitespace:%s*ignore%s*$") then
                goto continue
            end

            -- 清理空白
            local trimmed = text:gsub("%s+$", "")
            if trimmed:find("^%s*$") then
                trimmed = ""
            end
            lines[i] = trimmed

            ::continue::
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(0, cursor)
    end,
})

-- 保存文件时自动创建不存在的目录
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_mkdir"),
    callback = function(event)
        -- 跳过网络路径
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p") -- 递归创建目录
    end,
})
