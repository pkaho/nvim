local opt = vim.opt

opt.clipboard = "unnamedplus" -- 需要xclip, hyprland需要wl-clipboard
opt.mouse = "a" -- 启用鼠标支持
opt.hidden = true -- 切换buffer的时候，不提示未保存
opt.cursorline = true -- 显示光标行

-- 行号
opt.number = true -- 显示行号
opt.relativenumber = true -- 相对行号

-- 自动换行
opt.wrap = false -- 文本不自动换行(超出窗口显示为单行)
opt.linebreak = true -- 在单词边界处换行, 而不是任意字符处
opt.showbreak = "↪ " -- 在换行处显示一个符号, 表明是续行

-- 弹出窗口
opt.pumblend = 10 -- 设置弹窗透明度
opt.pumheight = 10 -- 设置弹窗显示的条目数

-- 搜索
opt.ignorecase = true -- 忽略大小写
opt.smartcase = true -- 搜索内容包含大小写, 则精确搜索

-- tab
opt.expandtab = true -- 使用空格作为tab而不是\t
opt.tabstop = 4 -- tab字符宽度
opt.shiftwidth = 4 -- 自动缩进/格式化的时候的缩进宽度
opt.softtabstop = 4 -- 按下tab键, 插入的tab宽度

-- undo
opt.undofile = true -- 持久化撤销到硬盘, 文件重新打开也可以继续撤销上一次的改动
opt.undolevels = 12345  -- 最大撤销次数 

-- [
-- swapfile: 文件打开的时候生成.swp文件, 正常退出时会自动删除, 防止编辑中崩溃
-- backupskip: 优先级在backup, writebackup之上, 在指定的文件类型或路径中跳过备份机制
-- backup: 保存时在文件所在目录(可通过backupdir指定位置)生成~后缀文件, 除非手动删除, 否则永久存在
-- writebackup: 保存成功后, 会自动删除~后缀文件, 除非backup启用, 防止保存时断电
-- ]
opt.swapfile = false -- 禁用打开文件时自动生成.swp后缀的交换文件(内存中操作)
opt.backup = false
opt.writebackup = true
opt.backupskip = {
    "/tmp/*"
}

-- 使用Windows并且已经安装pwsh时, 切换默认终端为pwsh
if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"
    opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
    opt.shellxquote = ''
end
