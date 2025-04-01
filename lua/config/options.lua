local opt = vim.opt

vim.g.snacks_animate = false  -- 禁用 Snacks 动画

opt.number = true             -- 行号
opt.relativenumber = true     --相对行号
opt.hidden = true             -- 切换 buffer 的时候，不提示当前 buffer 未保存
opt.wrap = false              -- 包裹行
opt.cursorline = true         -- 显示光标行
opt.termguicolors = true      -- 启动终端的 True Color
opt.inccommand = "split"      -- substitute 命令显示预览窗口
opt.clipboard = "unnamedplus" -- 需要 xclip, hyprland 需要 wl-clipboard
opt.mouse = "a"               -- 启用鼠标支持
-- opt.grepprg = "rg --vimgrep"
-- opt.linebreak = true
-- opt.list = true
-- opt.pumblend = 10
-- opt.pumheight = 10

opt.ignorecase = true -- 忽略大小写
opt.smartcase = true  -- 当搜索内容包含大写时, 不忽略大小写

opt.tabstop     = 4      -- Tab 宽度
opt.shiftwidth  = 4      -- 缩进宽度
opt.softtabstop = 4      -- 软 Tab 宽度
opt.expandtab   = true   -- Tab 转换成空格

opt.undofile = true
opt.undolevels = 12345

-- backup:      保存文件时创建一个备份文件，通常以 ~ 作为扩展名，可以通过 backupdir 指定目录
-- writebackup: 保存文件时创建一个备份文件，不同于 backup，仅用于保存操作期间的临时存储，防止保存文件时因磁盘或程序错误导致数据丢失
-- swapfile:    用于在编辑文件时保存未保存的更改，临时文件，用于程序崩溃时恢复数据                                                                                                       --]
opt.backup      = false
opt.writebackup = false
opt.swapfile    = false

if vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"
end
