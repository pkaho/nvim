return {
    -- snacks.nvim: 多功能工具集 (搜索 picker / 文件树 explorer / 启动页 / 终端 / 行内提示等)
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            vim.g.snacks_animate = true
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
    },
}
