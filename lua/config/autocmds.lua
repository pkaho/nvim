local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- 禁用换行自动添加注释
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
    group = augroup("format_options"),
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- 重新打开文件时恢复上次光标位置
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" } -- 排除的文件类型列表（例如 Git 提交信息）
        local buf = event.buf           -- 获取当前缓冲区的 ID
        -- 如果当前文件类型在排除列表，或者已经处理过，则直接返回
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true                   -- 标记该缓冲区已处理（避免重复执行）
        local mark = vim.api.nvim_buf_get_mark(buf, '"')     -- 获取最后位置标记
        local lcount = vim.api.nvim_buf_line_count(buf)      -- 获取当前缓冲区的总行数
        -- 如果标记位置有效（在文件范围内），则跳转到该位置
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)      -- 安全跳转（避免出错）
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

-- 特定类型文件开启换行和拼写检查
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("text_file_settings"),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true  -- 自动换行
        vim.opt_local.spell = true -- 拼写检查
    end,
})

-- 修复 JSON 文件的显示问题
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("json_settings"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0 -- 禁用隐藏字符功能
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

-- 保存和恢复缓冲区折叠状态
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWinEnter" }, {
    group = augroup("remember_folds"),
    callback = function(event)
        if vim.bo[event.buf].buftype ~= "" or vim.fn.expand("%") == "" then
            return
        end

        if event.event == "BufWinLeave" then
            vim.cmd.mkview()
        elseif event.event == "BufWinEnter" then
            vim.cmd("silent! loadview")
        end
    end,
    desc = "Remember and restore folds when leaving/entering buffers",
})

-- nvim-lspconfig 官方自动折叠导入内容
vim.api.nvim_create_autocmd('LspNotify', {
    group = augroup("auto_fold_imports"),
    callback = function(args)
        if args.data.method == 'textDocument/didOpen' then
            vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
        end
    end,
})

-- 当光标停留在错误行时显示浮动窗口
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         local opts = {
--             focusable = false,
--             close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--             border = 'rounded',
--             source = 'always',
--             prefix = ' ',
--         }
--         vim.diagnostic.open_float(nil, opts)
--     end
-- })


-- 更智能的显示（仅在诊断存在的行触发）
local ns = vim.api.nvim_create_namespace('dynamic_diag')
-- vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "CursorHold"}, {
--     callback = function()
--         -- 清除之前的高亮
--         vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
--
--         -- 获取当前行诊断
--         local line = vim.fn.line('.') - 1
--         local diags = vim.diagnostic.get(0, { lnum = line })
--
--         if #diags == 0 then return end
--
--         -- 自定义虚拟文本格式
--         local lines = {}
--         for _, d in ipairs(diags) do
--             table.insert(lines, string.format(
--                 "%s %s",
--                 ({ " ", " ", " ", " " })[d.severity],
--                 d.message:gsub("\n", " ")
--             ))
--         end
--
--         -- 手动添加虚拟文本
--         vim.api.nvim_buf_set_extmark(0, ns, line, 0, {
--             virt_text = { { table.concat(lines, " | "), "DiagnosticVirtualTextInfo" } },
--             virt_text_pos = 'eol', -- 行尾显示
--             hl_mode = 'combine'
--         })
--     end
-- })
