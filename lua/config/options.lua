-- 更多options可以参考:
-- `:h option-list`
-- `:h nvim-features` options 部分

local opt = vim.opt

--------------------
-- 基本设置
--------------------
opt.clipboard = "unnamedplus"   -- 系统剪贴板集成(需要xclip/wl-clipboard)
opt.mouse = "a"                 -- 全模式鼠标支持
opt.hidden = true               -- 允许隐藏未保存的缓冲区
opt.cursorline = true           -- 高亮当前行
opt.textwidth = 120             -- 行最大宽度(影响自动格式化)

--------------------
-- 行号设置
--------------------
opt.number = true               -- 显示绝对行号
opt.relativenumber = true       -- 显示相对行号

--------------------
-- 文本显示与换行
--------------------
opt.wrap = false               -- 禁止自动换行
opt.linebreak = true           -- 在单词边界换行
opt.showbreak = "↪ "           -- 续行标识符号

--------------------
-- 搜索设置
--------------------
opt.ignorecase = true          -- 搜索忽略大小写
opt.smartcase = true           -- 智能大小写(有大写时精确匹配)
opt.inccommand = "split"       -- 替换的时候在下方显示预览窗口

--------------------
-- Tab与缩进
--------------------
opt.expandtab = true           -- 将Tab转换为空格
opt.tabstop = 4                -- Tab显示宽度
opt.shiftwidth = 4             -- 自动缩进宽度
opt.softtabstop = 4            -- 编辑时Tab键插入空格数

--------------------
-- 撤销历史
--------------------
opt.undofile = true            -- 持久化撤销历史
opt.undolevels = 12345         -- 最大撤销步数

--------------------
-- 文件备份策略
--------------------
opt.swapfile = true            -- 禁用交换文件
opt.backup = false             -- 禁用备份文件
opt.writebackup = true         -- 写入时临时备份
opt.backupskip = {             -- 跳过备份的文件类型
    '/tmp/*',         -- 临时文件
    '/private/tmp/*', -- macOS 临时文件
    '*.swp',          -- Vim 交换文件
    '*.bak',          -- 备份文件
    '*.pyc',          -- Python 字节码
    '*.class',        -- Java 字节码
    '*.o',            -- 编译对象文件
    'node_modules/*', -- Node.js 依赖
    '.git/*',         -- Git 目录
    '.svn/*',         -- SVN 目录
    '__pycache__/*',  -- Python 缓存
}

--------------------
-- 用户界面增强
--------------------
opt.pumblend = 10              -- 弹出菜单透明度
opt.pumheight = 10             -- 弹出菜单最大高度

--------------------
-- Windows特定设置
--------------------
if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"                          -- 使用PowerShell作为默认shell
    opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
    opt.shellxquote = ''
end
