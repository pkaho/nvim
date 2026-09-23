local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">"
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end

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
            { "<leader><Space>", function() Snacks.picker.files() end,         desc = "File Search" },
            { "<leader>/",       function() Snacks.picker.grep() end,          desc = "Grep" },
            { '<leader>"',       function() Snacks.picker.registers() end,     desc = "Registers" },
            { "<leader>sh",      function() Snacks.picker.help() end,          desc = "Search Help" },
            { "<leader>sb",      function() Snacks.picker.grep_buffers() end,  desc = "Grep inside Buffers" },
            { "<leader>sp",      function() Snacks.picker.projects() end,      desc = "Search .git Projects" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,       desc = "Search Keymaps" },
            { "<leader>st",      function() Snacks.picker.todo_comments() end, desc = "Search Todo" },
            { "<leader>e",       function() Snacks.explorer() end,             desc = "Explorer" },
            { "<leader>cz",      function() Snacks.zen.zoom() end,             desc = "Toggle Zoom" },
            { "<leader>cZ",      function() Snacks.zen() end,                  desc = "Toggle Zen" },
            { "<leader>,",       function() Snacks.picker.buffers() end,       desc = "Search Buffers" },
            { "<leader>.",       function() Snacks.scratch() end,              desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,       desc = "Select Scratch Buffer" },
            { "<leader>dps",     function() Snacks.profiler.scratch() end,     desc = "Profiler Scratch Buffer" },
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
            terminal = {
                win = {
                    keys = {
                        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                        hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
                        hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
                    },
                },
            },
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
            Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
            Snacks.toggle.zen():map("<leader>uz")
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
                .option("background", {
                    off = "light",
                    on = "dark",
                    name = "Dark Background",
                })
                :map("<leader>ub")
        end,
    },
}
