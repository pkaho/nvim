-- lua_ls 专属配置（纯原生 vim.lsp.config，不依赖任何插件挂载）
--
-- 执行时机：本文件在 lazy 的 import 阶段（启动早期）被顶层直接执行，
-- 此时 vim.lsp.config 已可用；server 级配置会覆盖 vim.lsp.config("*") 的默认值
-- （见本目录 core.lua），与注册顺序无关。
-- 返回空表是合法的：lazy 的 normalize 对空 list 走空循环，不会注册任何插件。
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" }, -- Neovim 内置 LuaJIT，避免按 Lua 5.4 推断 API
            telemetry = { enable = false }, -- 关闭遥测上报
            diagnostics = {
                -- LuaLS 3.9+ 不再默认把 require 视为全局，需显式声明
                globals = { "vim", "require" },
            },
        },
    },
})

return {}
