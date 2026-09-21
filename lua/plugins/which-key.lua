return {
    -- which-key: 按键提示
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<C-w><Space>",
                function()
                    require("which-key").show({ keys = "<C-w>", loop = true })
                end,
                desc = "Windows Hydra Mode (which-key)",
            }
        },
        opts = {
            preset = "helix",
            spec = {
                mode = { "n", "x" },
                { "<leader><tab>", group = "tabs" },
                { "<leader>c",     group = "code" },
                { "<leader>f",     group = "file/find" },
                { "<leader>g",     group = "git" },
                { "<leader>gh",    group = "hunks" },
                { "<leader>q",     group = "quit/session" },
                { "<leader>s",     group = "search" },
                { "<leader>sn",    group = "noice" },
                { "<leader>u",     group = "ui" },
                { "<leader>x",     group = "diagnostics/quickfix" },
                { "[",             group = "prev" },
                { "]",             group = "next" },
                { "g",             group = "goto" },
                { "z",             group = "fold" },
                { "gs",            group = "surround" },
                { "gx",            desc = "Open with system app" },
                {
                    "<leader>w",
                    group = "windows",
                    expand = function()
                        return require("which-key.extras").expand.win()
                    end
                },
                {
                    "<leader>b",
                    group = "buffer",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end
                },
            },
            icons = {
                mappings = false,
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            },
            plugins = {
                marks = true,         -- ' 或 ` 显示 marks 列表
                registers = true,     -- NORMAL 模式使用 ” 显示寄存器中的复制内容
                spelling = {
                    enabled = true,   -- 按下 z= 显示拼写检查列表
                    suggestions = 20, -- 列表长度
                },
                presets = {
                    operators = true,    -- 显示操作符帮助，如 d,y,c 等
                    motions = true,      -- 显示移动操作帮助
                    text_objects = true, -- 显示文本对象帮助，nvim 的 ai 操作
                    windows = true,      -- 显示 Ctrl+w 相关的窗口操作快捷键
                    nav = true,          -- 显示窗口导航相关的其他绑定
                    z = true,            -- 显示 z 开头的快捷键
                    g = true,            -- 显示 g 开头的快捷键
                },
            },
        },
    },
}
