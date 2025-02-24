-- 通过设置 formatoptions 实现换行不自动注释
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})
