local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.hidden = true
opt.inccommand = "split" -- s 命令显示预览窗口
opt.wrap = false -- 包裹行

opt.tabstop = 2 -- Tab 宽度
opt.shiftwidth = 2 -- 缩进宽度
opt.softtabstop = 2 -- 软 Tab 宽度
opt.expandtab = true -- Tab 转换成空格

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.clipboard = "unnamedplus" -- need xclip

if vim.fn.executable("pwsh") == 1 then
	opt.shell = "pwsh"
end
