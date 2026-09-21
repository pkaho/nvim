return {
    -- snacks.nvim: 多功能工具集
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            vim.g.snacks_animate = false -- 关闭 snacks 动画（减少操作时的视觉开销）
        end,
        keys = {
            -- stylua: ignore start
            { "<leader><Space>", "<cmd>lua Snacks.picker.files()<CR>",         desc = "File Search" },
            { "<leader>/",       "<cmd>lua Snacks.picker.grep()<CR>",          desc = "Grep" },
            { '<leader>"',       "<cmd>lua Snacks.picker.registers()<CR>",     desc = "Registers" },
            { "<leader>sh",      "<cmd>lua Snacks.picker.help()<CR>",          desc = "Search Help" },
            { "<leader>sb",      "<cmd>lua Snacks.picker.grep_buffers()<CR>",  desc = "Grep inside Buffers" },
            { "<leader>sp",      "<cmd>lua Snacks.picker.projects()<CR>",      desc = "Search .git Projects" },
            { "<leader>sk",      "<cmd>lua Snacks.picker.keymaps()<CR>",       desc = "Search Keymaps" },
            { "<leader>st",      "<cmd>lua Snacks.picker.todo_comments()<CR>", desc = "Search Todo" },
            { "<leader>e",       "<cmd>lua Snacks.explorer()<CR>",             desc = "Explorer" },
            { "<leader>cz",      "<cmd>lua Snacks.zen.zoom()<CR>",             desc = "Toggle Zoom" },
            { "<leader>cZ",      "<cmd>lua Snacks.zen()<CR>",                  desc = "Toggle Zen" },
            { "<leader>,",       "<cmd>lua Snacks.picker.buffers()<CR>",       desc = "Search Buffers" },
            -- stylua: ignore end
            {
                "<c-/>",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Terminal",
            },
            {
                "<c-_>",
                function()
                    Snacks.terminal()
                end,
                desc = "which_key_ignore",
            },
        },
        opts = {
            bigfile = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = false }, -- 由 noice.nvim 接管通知
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = false },
            words = { enabled = true },
            picker = {
                hidden = true, -- 显示 explorer 中的隐藏文件
                sources = {
                    files = { hidden = true }, -- 显示 picker 中的隐藏文件
                    explorer = {
                        layout = {
                            -- auto_hide = { "input" }, -- 隐藏搜索框, 只有按下 / 或者 i 才会显示
                        },
                    },
                },
            },
            dashboard = {
                enabled = true,
                preset = {
                    keys = {
                        {
                            icon = "󰈞 ",
                            key = "f",
                            desc = "Find files",
                            action = ":lua Snacks.dashboard.pick('files')",
                        },
                        { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua Snacks.dashboard.pick('live_grep')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent files",
                            action = ":lua Snacks.dashboard.pick('oldfiles')",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                        },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                    header = [[
 ▄▄    ▄ ▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄▄
█  █  █ █      █  █  █ █       █
█   █▄█ █  ▄   █   █▄█ █   ▄   █
█       █ █▄█  █       █  █ █  █
█  ▄    █      █  ▄    █  █▄█  █
█ █ █   █  ▄   █ █ █   █       █
█▄█  █▄▄█▄█ █▄▄█▄█  █▄▄█▄▄▄▄▄▄▄█
                    ]],
                    sections = {
                        { section = "header" },
                        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                    },
                },
            },
        },
        config = function(_, opts)
            require("snacks").setup(opts)
            -- 诊断跳转键已统一放在 config/keybinds.lua (此处不再重复定义)
            -- UI 开关（<leader>u* 组，Snacks.toggle）
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.dim():map("<leader>uD")
            Snacks.toggle.animate():map("<leader>ua")
            Snacks.toggle.indent():map("<leader>ug")
            Snacks.toggle.scroll():map("<leader>uS")
            Snacks.toggle.profiler():map("<leader>dpp")
            Snacks.toggle.profiler_highlights():map("<leader>dph")
            Snacks.toggle
                .option("conceallevel", {
                    off = 0,
                    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
                    name = "Conceal Level",
                })
                :map("<leader>uc")
            Snacks.toggle
                .option("showtabline", {
                    off = 0,
                    on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
                    name = "Tabline",
                })
                :map("<leader>uA")
            Snacks.toggle
                .option("background", { off = "light", on = "dark", name = "Dark Background" })
                :map("<leader>ub")
        end,
    },
}
