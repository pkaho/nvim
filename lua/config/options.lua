-- 更多options可以参考:
-- `:h option-list`
-- `:h nvim-features` options 部分

local opt = vim.opt

--------------------
-- 基本设置
--------------------
opt.clipboard = "unnamedplus"      -- 系统剪贴板集成(需要xclip/wl-clipboard)
opt.mouse = "a"                    -- 全模式鼠标支持
opt.hidden = true                  -- 允许隐藏未保存的缓冲区
opt.cursorline = true              -- 高亮当前行
opt.textwidth = 120                -- 行最大宽度(影响自动格式化)
opt.termguicolors = true           -- 设置真彩色(1670万色), 传统只支持256色(8bit)
opt.autowrite = true               -- 切换缓冲区或离开nvim时自动保存
opt.list = true                    -- 显示不可见字符
opt.laststatus = 3                 -- 全局状态栏(所有窗口共享一个状态栏)
opt.showmode = true                -- 显示模式
opt.ruler = true                   -- 状态栏显示光标位置
opt.timeoutlen = 300               -- 按键超出时间
opt.updatetime = 200               -- 触发CursorHold事件的时间间隔
opt.virtualedit = "block"          -- 可视块模式下允许光标移动到无文本处
opt.wildmode = "longest:full,full" -- 命令行补全模式
opt.conceallevel = 2               -- 隐藏某些文本(如Markdown的粗/斜体标记)

--------------------
-- 基本设置
--------------------
opt.foldlevel = 99              -- 默认展开所有折叠
opt.foldmethod = "expr"         -- 折叠方式, expr(表达式)
opt.foldexpr = "v:lua.nvim.treesitter.foldexpr()" -- 使用treesitter进行折叠

--------------------
-- 窗口设置
--------------------
opt.splitbelow = true           -- 新窗口在下方打开
opt.splitright = true           -- 新窗口在右边打开
opt.splitkeep = "screen"        -- 分割的窗口保持屏幕滚动位置
opt.winminwidth = 10            -- 全局窗口最小宽度

--------------------
-- 滚动设置
--------------------
opt.scrolloff = 4               -- 光标距离窗口顶部/底部保留的行数
opt.sidescrolloff = 8           -- 光标距离窗口左右边缘保留的行数

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
-- 搜索和替换设置
--------------------
opt.ignorecase = true          -- 搜索忽略大小写
opt.smartcase = true           -- 智能大小写(有大写时精确匹配)
opt.inccommand = "split"       -- 替换的时候在下方显示预览窗口
opt.grepformat = "%f:%l:%c:%m" -- 设置grep输出格式
if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep"
end

--------------------
-- Tab与缩进
--------------------
opt.expandtab = true           -- 将Tab转换为空格
opt.tabstop = 4                -- Tab显示宽度
opt.shiftwidth = 4             -- 自动缩进宽度
opt.shiftround = true          -- 缩进时对齐到shiftwidth的倍数
opt.softtabstop = 4            -- 编辑时Tab键插入空格数
opt.smartindent = true         -- 根据上下文自动调整缩进级别

--------------------
-- 撤销历史
--------------------
opt.undofile = true            -- 持久化撤销历史
opt.undolevels = 12345         -- 最大撤销步数

--------------------
-- 文件备份策略
--------------------
opt.swapfile = true            -- .swp交换文件, 成功保存会自动删除
opt.backup = false             -- ~后缀的备份文件, 不手动删除永远存在
opt.writebackup = true         -- 写入时临时~后缀的备份文件, 成功保存会自动删除
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
-- 弹窗设置
--------------------
--[
-- menu    : 使用弹出菜单
-- menuone : 即使只有一个匹配项也显示菜单
-- noselect: 不自动选择第一个匹配项
--]
opt.completeopt = "menu,menuone,noselect" -- 菜单补全行为
opt.pumblend = 10              -- 弹出菜单透明度
opt.pumheight = 10             -- 弹出菜单最大高度
opt.confirm = true             -- 退出时有未保存更改是显示确认对话框

--------------------
-- Windows特定设置
--------------------
-- 避免lazygit显示出现问题
if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"                          -- 使用PowerShell作为默认shell
    opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
    opt.shellxquote = ''
end
