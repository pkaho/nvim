-- LSP 域入口：import = "plugins" 会加载含 init.lua 的子目录，
-- 这里用 import 引入本目录的 spec（lazy 对已导入模块有防循环保护）
return {
    { import = "plugins.lsp" },
}
