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

-- 返回空表是合法的：lazy 的 normalize 对空 list 走空循环，不会注册任何插件。
return {}
