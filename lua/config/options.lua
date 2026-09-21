local opt = vim.opt

-- 新UI，收缩长提示消息，末尾展示省略行数，如：[+x]
require("vim._core.ui2").enable()

opt.termguicolors = true -- 启用终端24位真彩色

-- 延迟设置剪贴板，减少启动阻塞；同步系统剪贴板
-- Wayland 依赖 wl-clipboard，X11 依赖 xclip
vim.schedule(function()
    opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
end)

opt.mouse = "a" -- 全模式启用鼠标支持
opt.timeoutlen = 300 -- 组合键前缀等待超时时间，毫秒
opt.updatetime = 200 -- CursorHold 触发、swap 文件写入延迟

-- 行列设置
opt.number = true -- 绝对行号
opt.relativenumber = true -- 相对行号
opt.signcolumn = "yes" -- 保留左侧诊断/标记列，避免界面跳动
opt.numberwidth = 4 -- 标记列宽度
opt.cursorline = true -- 高亮光标所在行

-- 缩进
local tabsize = 4
opt.expandtab = true -- Tab 转空格，不插入真实制表符
opt.tabstop = tabsize -- 文件中 \t 字符宽度
opt.softtabstop = tabsize -- 按 Tab 时，字符宽度
opt.shiftwidth = tabsize -- >>/<< 缩进宽度
opt.shiftround = true -- 缩进自动对齐到 shiftwidth 整数倍
opt.smartindent = true -- 代码块自动缩进

-- 搜索、grep
opt.ignorecase = true -- 搜索默认忽略大小写
opt.smartcase = true -- 搜索大写字母时区分大小写
opt.inccommand = "split" -- :substitute 命令分屏预览
opt.grepformat = "%f:%l:%c:%m" -- grep 输出格式适配 quickfix 窗口
-- 存在 ripgrep 时，使用 ripgrep 替换内置 grep
if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep"
end

-- 撤销
opt.undofile = true -- 持久化撤销历史，重启文件后仍可撤销
opt.undolevels = 12345 -- 单文件最大可撤销步数上限

-- 分屏、窗口布局
opt.splitbelow = true -- :split 水平分屏，新窗口在下方
opt.splitright = true -- :vsplit 垂直分屏，新窗口在右侧
opt.splitkeep = "topline" -- 分割窗口后，保持原窗口顶部显示内容不变
opt.winminwidth = 10 -- 所有窗口最小宽度限制

-- 滚动边距、文本折行
opt.scrolloff = 4 -- 光标上下预留4行空白
opt.sidescrolloff = 8 -- 光标左右预留8行空白
opt.smoothscroll = true -- 滚动时平滑过渡（像素级动画，实验性；对 gj/gk 尚未实现）
opt.wrap = false -- 长单行不自动折行，横向滚动查看
opt.linebreak = true -- 折行时仅在单词边界断开（仅在 wrap 开启时生效）
opt.breakindent = true -- 折行续行保持和首行相同缩进层级
opt.showbreak = "↪ " -- 折行续行前缀标识，按需开启

-- 自动补全（内置触发默认关闭，补全由 blink.cmp 接管）
opt.complete = ".,w,b,u,t" -- 补全来源
opt.completeopt = "menu,menuone,noselect" -- 补全菜单：仅弹窗、不自动选中第一项
opt.wildmode = "longest:full,full" -- 命令行 Tab 补全逻辑：先最长匹配，再完整列表

-- Buffer
opt.hidden = true -- 当前 buffer 存在未保存修改时，切换离开这个 buffer，不再强制报错阻止切换
opt.autowrite = true -- 当前 buffer 存在未保存修改时，遇到 buffer 跳转、外部 shell 执行等命令会自动保存，注意：hidden buffer 行为不会自动写入（如：:edit）
opt.confirm = true -- 退出/关闭修改文件时弹出确认弹窗

-- Conceal 语法隐藏
opt.conceallevel = 2 -- 语法标记隐藏等级：完全隐藏匹配媳妇（Markdown/**、#、LaTeX 符号等）
opt.concealcursor = "nv" -- 控制光标行隐藏规则：Normal/Visual 模式仍隐藏标记；Insert 插入模式自动显示原始字符

opt.list = true -- 显示 Tab、尾随空格等不可见字符
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- 自定义不可见字符样式
opt.ruler = false -- 行列信息由 lualine 接管; 开启时会在 dashboard 等禁用状态栏的界面右下角残留行列显示
opt.cmdheight = 0 -- 不常驻命令行行, 消除全局状态栏(lualine)下方的空行; 有命令/消息时临时显示
opt.showmode = false -- 关闭底部原生 `-- INSERT --` 模式显示，这里关闭会影响 noice.api.status.mode 的显示
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.jumpoptions = "view"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- 文件备份策略
opt.swapfile = true -- 开启 .swp 交换文件，异常崩溃恢复内容
opt.writebackup = true -- 保存前生成临时 ~ 备份，写入成功自动删除
opt.backup = false -- 关闭永久保留 ~ 备份文件（仅临时备份）
-- 指定目录/文件跳过生成 ~ 临时备份
opt.backupskip = {
    "*.swp", -- Vim 交换文件
    "*.bak", -- 备份文件
    "*.pyc", -- Python 字节码
    "*.class", -- Java 字节码
    "*.o", -- 编译对象文件
    "node_modules/*", -- 临时文件
    ".git/*", -- Git 目录
    ".svn/*", -- SVN 目录
    "/tmp/*", -- 临时文件
    "/private/tmp/*", -- macOS 临时文件
    "__pycache__/*", -- Python 缓存
}
