-- 通过设置 formatoptions 实现换行不自动注释
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
    pattern = { "*" },
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- 记忆最后一次编辑的位置，不同于常规使用 mark 的方式
-- 利用 view 功能实现记忆上一次编辑位置的功能
vim.opt.viewoptions:append("cursor")
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd('mkview')
        end
    end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd('silent! loadview')
        end
    end,
})

-- 高亮复制行
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- 特定类型文件开启换行和拼写检查
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- 修复 JSON 文件的屏蔽
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- 保存文件时自动创建文件夹，以防某些中间文件夹不存在
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
