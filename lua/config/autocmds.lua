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
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd('mkview')
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd('silent! loadview')
        end
    end,
})

