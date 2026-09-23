-- 功能域注册表：集中声明 lua/plugins/ 下各功能域目录
-- lazy 的 import = "plugins" 会自动加载本文件；本文件返回的 import 会递归加载各域内的所有 .lua
-- 新增功能域：新建目录 → 在此加一行 { import = "plugins.<域>" }；域内文件无需再写 init.lua
return {
    { import = "plugins.ui" }, -- 界面：状态栏 / 标签栏 / 通知 / dashboard / picker / 主题
    { import = "plugins.lsp" }, -- 语言服务：mason / 补全 / LSP 客户端与按语言拆分
    { import = "plugins.editing" }, -- 编辑增强：配对 / 多光标 / 文本对象 / 递增
    { import = "plugins.search" }, -- 搜索导航：跨文件替换 / 快速跳转 / TODO
    { import = "plugins.git" }, -- git 集成：gitsigns / lazygit
    { import = "plugins.lang" }, -- 语言与格式：treesitter / 格式化 / lint / 专用语言
    { import = "plugins.tools" }, -- 工具杂项：任务运行器 / 会话
}
