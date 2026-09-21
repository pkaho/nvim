-- LSP 配置目录入口
-- 本文件被 lua/plugins/ 的父 import 自动加载 (目录含 init.lua)。
-- 通过转发 import 加载同目录其他配置, 由 lazy 的 import 去重避免重复注册:
--   core.lua  -- LSP 核心 (mason / 补全引擎 / nvim-lspconfig 客户端与全局按键)
--   lua.lua   -- lua_ls 专属配置 (按语言继续拆分)
-- 若想改用 lazy 标准做法: 删除本文件, 并在 lua/config/lazy.lua 的 spec 中写 { import = "plugins.lsp" }
return {
    { import = "plugins.lsp" },
}
