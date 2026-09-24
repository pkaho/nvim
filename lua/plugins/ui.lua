-- snacks.nvim：终端窗口导航辅助函数（term_nav）
local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">"
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end

local custom_root = require("config.root")

return {
    -- bufferline: 顶部 buffer 标签栏
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            -- stylua: ignore start
            { "<leader>bb", "<CMD>e #<CR>",                              desc = "Switch to Other Buffer" },
            { "<leader>b`", "<CMD>e #<CR>",                              desc = "Switch to Other Buffer" },
            { "<leader>bd", function() Snacks.bufdelete() end,           desc = "Delete Buffer" },
            { "<leader>bo", function() Snacks.bufdelete.other() end,     desc = "Delete Other Buffers" },
            { "<leader>bi", function() Snacks.bufdelete.invisible() end, desc = "Delete Invisible Buffers" },
            { "<leader>ba", function() Snacks.bufdelete.all() end,       desc = "Delete All Buffers" },
            { "<leader>bD", "<CMD>:bd<CR>",                              desc = "Delete Buffer and Window" },
            { "<leader>bp", "<CMD>BufferLineTogglePin<CR>",              desc = "Toggle Pin" },
            { "<leader>bP", "<CMD>BufferLineGroupClose ungrouped<CR>",   desc = "Delete Non-Pinned Buffers" },
            { "<leader>br", "<CMD>BufferLineCloseRight<CR>",             desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<CMD>BufferLineCloseLeft<CR>",              desc = "Delete Buffers to the Left" },
            { "<leader>bj", "<CMD>BufferLinePick<cr>",                   desc = "Pick Buffer" },
            { "<S-h>",      "<CMD>BufferLineCyclePrev<cr>",              desc = "Prev Buffer" },
            { "<S-l>",      "<CMD>BufferLineCycleNext<cr>",              desc = "Next Buffer" },
            { "[b",         "<CMD>BufferLineCyclePrev<cr>",              desc = "Prev Buffer" },
            { "]b",         "<CMD>BufferLineCycleNext<cr>",              desc = "Next Buffer" },
            { "[B",         "<CMD>BufferLineMovePrev<cr>",               desc = "Move buffer prev" },
            { "]B",         "<CMD>BufferLineMoveNext<cr>",               desc = "Move buffer next" },
            -- stylua: ignore start
        },
        opts = {
            options = {
                close_command = function(n)
                    require("snacks").bufdelete(n)
                end,
                right_mouse_command = function(n)
                    require("snacks").bufdelete(n)
                end,
                always_show_bufferline = true,
                separator_style = "slope", -- slant | slope | thick | thin | { 'any', 'any' }
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diag)
                    local icons = {
                        Error = " ",
                        Warn = " ",
                        Hint = " ",
                        Info = " ",
                    }
                    local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                        .. (diag.warning and icons.Warn .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                    {
                        filetype = "snacks_layout_box",
                    },
                },
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)

            -- BufAdd / BufDelete 后刷新标签栏
            vim.api.nvim_create_autocmd({ "BufDelete", "BufAdd" }, {
                callback = function()
                    vim.schedule(function()
                        pcall(function()
                            vim.cmd.redrawtabline()
                        end)
                    end)
                end,
            })
        end,
    },

    -- nvim-colorizer: 高亮文件中的颜色代码
    {
        "catgoose/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" }, -- 打开文件时才高亮颜色
        opts = {},
    },

    -- ccc: 交互式颜色选择器
    -- (键位用 <leader>uC: <leader>uc 已被 snacks 的 Conceal Level toggle 占用)
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        keys = {
            { "<leader>uC", "<CMD>CccPick<CR>", desc = "Color Pick (ccc)" },
        },
        opts = {},
    },

    -- themify: 主题管理器
    -- (键位用 <leader>uB: <leader>ub 已被 snacks 的 Dark Background toggle 占用)
    {
        "lmantw/themify.nvim",
        lazy = false, -- 不设置懒加载，懒加载会导致主题不生效
        priority = 999, -- 保持优先级
        keys = {
            { "<leader>uB", "<CMD>Themify<CR>", desc = "Colorscheme Theme" },
        },
        opts = {
            "Shatur/neovim-ayu",
            "catppuccin/nvim",
            "kepano/flexoki-neovim",
            "rose-pine/neovim",
            "sainnhe/sonokai",
            "rebelot/kanagawa.nvim",
        },
    },

    -- lualine: 状态栏
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                vim.o.statusline = " "
            else
                vim.opt.laststatus = 0
            end
        end,
        opts = function()
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            local opts = {
                options = {
                    theme = "auto",
                    globalstatus = vim.o.laststatus == 3,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = " ",
                            },
                        },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { "filename" },
                    },

                    lualine_x = {
                        Snacks.profiler.status(),
                        {
                            function()
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.command.has()
                            end,
                            color = function()
                                return { fg = Snacks.util.color("Statement") }
                            end,
                        },
                        -- stylua: ignore
                        -- opt.showmode = false 关闭模式显示会减少这里的内容显示
                        -- 录制宏会有提示
                        {
                            function() return " " .. require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            color = function() return { fg = Snacks.util.color("Constant") } end,
                        },
                        -- nvim-dap 未安装，DAP 状态段已移除
                        -- stylua: ignore
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = function() return { fg = Snacks.util.color("Special") } end,
                        },
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        -- stylua: ignore
                        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
            }

            return opts
        end,
    },

    -- noice: 消息通知工具
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = {
            -- stylua: ignore start
            { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker" },
            { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, desc = "Redirect Cmdline", mode = "c" },
            -- stylua: ignore end
        },
        opts = {
            messages = {
                enabled = true,
                view = "mini",
                -- 错误/警告也走 mini 消息条（位置已上移到状态栏上方一行，见 views.mini）
                -- 保持统一的消息条风格，不再用 notify 弹窗
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages",
                view_search = "virtualtext",
            },
            cmdline = { enabled = true },
            views = {
                cmdline_popup = {
                    position = {
                        row = "30%",
                        col = "50%",
                    },
                },
                -- mini 消息条默认 row=-1（编辑器底部最后一行），正好盖住状态栏；
                -- 上移一行（row=-2）显示在状态栏上方
                mini = {
                    position = {
                        row = -2,
                        col = "100%",
                    },
                },
            },
            -- 接管 LSP 浮窗文档渲染（markdown 转换 / 样式美化），替代原生纯文本展示
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false, -- 激活 inc-rename.nvim 的输入对话框
            },
        },
        config = function(_, opts)
            if vim.o.filetype == "lazy" then
                vim.cmd([[message clear]])
            end
            require("noice").setup(opts)
        end,
    },

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
            { "<leader>,",       function() Snacks.picker.buffers() end,         desc = "Search Buffers" },
            { "<leader><Space>", function() Snacks.picker.files() end,           desc = "File Search" },
            { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>n",       function() Snacks.picker.notifications() end,   desc = "Notification History" },
            { "<leader>e",       function() Snacks.explorer() end,               desc = "Explorer" },
            { '<leader>"',       function() Snacks.picker.registers() end,       desc = "Registers" },
            -- Find
            { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc="FindConfig File" },
            { "<leader>fb",  function() Snacks.picker.buffers() end,            desc=  "Buffers" },
            { "<leader>ff",  function() Snacks.picker.files() end,              desc=    "FindFiles" },
            { "<leader>fg",  function() Snacks.picker.git_files() end,          desc ="FindGitFiles" },
            { "<leader>fp",  function() Snacks.picker.projects() end,           desc  ="Projects" },
            { "<leader>fr",  function() Snacks.picker.recent() end,             desc    ="Recent" },
            -- Grep
            { "<leader>/",   function() Snacks.picker.grep() end,               desc = "Grep" },
            { "<leader>sb",  function() Snacks.picker.grep_buffers() end,       desc = "Grep inside Buffers" },
            { "<leader>sB",  function() Snacks.picker.lines() end,              desc = "Buffer Lines" },
            { "<leader>sw",  function() Snacks.picker.grep_word() end,          desc = "Visual selection or word" },
            -- Search
            { '<leader>s"',  function() Snacks.picker.registers() end,          desc = "Registers" },
            { "<leader>s/",  function() Snacks.picker.search_history() end,     desc = "Search History" },
            { "<leader>sa",  function() Snacks.picker.autocmds() end,           desc = "Autocmds" },
            { "<leader>sc",  function() Snacks.picker.command_history() end,    desc = "Command History" },
            { "<leader>sC",  function() Snacks.picker.commands() end,           desc = "Commands" },
            { "<leader>sd",  function() Snacks.picker.diagnostics() end,        desc = "Diagnostics" },
            { "<leader>sD",  function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
            { "<leader>sh",  function() Snacks.picker.help() end,               desc = "Help Pages" },
            { "<leader>sH",  function() Snacks.picker.highlight() end,          desc = "Highlights" },
            { "<leader>si",  function() Snacks.picker.icons() end,              desc = "Icons" },
            { "<leader>sj",  function() Snacks.picker.jumps() end,              desc = "Jumps" },
            { "<leader>sk",  function() Snacks.picker.keymaps() end,            desc = "Keymaps" },
            { "<leader>sl",  function() Snacks.picker.loclist() end,            desc = "Location List" },
            { "<leader>sm",  function() Snacks.picker.marks() end,              desc = "Marks" },
            { "<leader>sM",  function() Snacks.picker.man() end,                desc = "Man Pages" },
            { "<leader>sp",  function() Snacks.picker.projects() end,           desc = "Search .git Projects" },
            { "<leader>sP",  function() Snacks.picker.lazy() end,               desc = "Search for Plugin Spec" },
            { "<leader>sq",  function() Snacks.picker.qflist() end,             desc = "Quickfix List" },
            { "<leader>sR",  function() Snacks.picker.resume() end,             desc = "Resume" },
            { "<leader>su",  function() Snacks.picker.undo() end,               desc = "Undo History" },
            { "<leader>sC",  function() Snacks.picker.colorschemes() end,       desc = "Colorschemes" },
            -- Zen
            { "<leader>cz",  function() Snacks.zen.zoom() end,                  desc = "Toggle Zoom" },
            { "<leader>cZ",  function() Snacks.zen() end,                       desc = "Toggle Zen" },
            -- Scratch
            { "<leader>.",   function() Snacks.scratch() end,                   desc = "Toggle Scratch Buffer" },
            { "<leader>S",   function() Snacks.scratch.select() end,            desc = "Select Scratch Buffer" },
            { "<leader>dps", function() Snacks.profiler.scratch() end,          desc = "Profiler Scratch Buffer" },
            -- Terminal
            { "<leader>fT",  function() Snacks.terminal() end,                  desc = "Terminal (cwd)" },
            { "<leader>ft", function() Snacks.terminal(nil, { cwd = custom_root() }) end, desc = "Terminal (Root Dir)" },
            { "<C-/>", function() Snacks.terminal.focus(nil, { cwd = custom_root() }) end, desc = "Terminal (Root Dir)", mode = { "n", "x" } },
            { "<C-_>", function() Snacks.terminal.focus(nil, { cwd = custom_root() }) end, desc = "which_key_ignore", mode = { "n", "x" } },
            -- Jump
            { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next References", mode = { "n", "t" } },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev References", mode = { "n", "t" } },
            -- Other
            { "<leader>cR",     function() Snacks.rename.rename_file() end,       desc = "Rename File" },
            { "<leader>un",     function() Snacks.notifier.hide() end,       desc = "Dismiss All Notifications" },
            { "<leader>n",     function()
                if Snacks.config.picker and Snacks.config.picker.enabled then
                    Snacks.picker.notifications()
                else
                    Snacks.notifier.show_history()
                end
            end, desc = "Notification History" },
            { "<leader>N", function ()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file("doc/new.txt", false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = "yes",
                        statuscolumn = " ",
                        conceallevel = 3,
                    }
                })
            end, desc = "Neovim News" }
,
            -- stylua: ignore end
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
                        hide_underscore = { "<C-_>", "hide", desc = "which_key_ignore", mode = "t" },
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
            if vim.lsp.inlay_hint then
                Snacks.toggle.inlay_hints():map("<leader>uh")
            end
        end,
    },

    -- trouble: 诊断 / quickfix / LSP 列表窗口
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            -- stylua: ignore start
            { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
            { "<leader>cl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP Refs / Defs (Trouble)" },
            { "<leader>xL", "<CMD>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<CMD>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
            -- stylua: ignore start
            -- {
            --     "[q",
            --     function()
            --         if require("trouble").is_open() then
            --             require("trouble").prev({ skip_groups = true, jump = true })
            --         else
            --             local ok, err = pcall(vim.cmd.cprev)
            --             if not ok then
            --                 vim.notify(err, vim.log.levels.ERROR)
            --             end
            --         end
            --     end,
            --     desc = "Previous Trouble/Quickfix Item",
            -- },
            -- {
            --     "]q",
            --     function()
            --         if require("trouble").is_open() then
            --             require("trouble").next({ skip_groups = true, jump = true })
            --         else
            --             local ok, err = pcall(vim.cmd.cnext)
            --             if not ok then
            --                 vim.notify(err, vim.log.levels.ERROR)
            --             end
            --         end
            --     end,
            --     desc = "Next Trouble/Quickfix Item",
            -- },
        },
    },

    -- which-key: 按键提示
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<C-w><Space>",
                function()
                    require("which-key").show({ keys = "<C-w>", loop = true })
                end,
                desc = "Windows Hydra Mode (which-key)",
            },
        },
        opts = {
            preset = "helix",
            spec = {
                mode = { "n", "x" },
                { "<leader><tab>", group = "tabs" },
                { "<leader>c", group = "code" },
                { "<leader>o", group = "overseer" },
                { "<leader>cp", group = "lsp (picker)" },
                { "<leader>cg", group = "glance" },
                { "<leader>cpa", group = "lsp calls (picker)" },
                { "<leader>d", group = "profiler" },
                { "<leader>e", group = "explorer" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                { "<leader>gh", group = "hunks" },
                { "<leader>l", group = "lint" },
                { "<leader>m", group = "multi-cursor" },
                { "<leader>q", group = "quit/session" },
                { "<leader>s", group = "search" },
                { "<leader>sn", group = "noice" },
                { "<leader>u", group = "ui" },
                { "<leader>x", group = "diagnostics/quickfix" },
                { "[", group = "prev" },
                { "]", group = "next" },
                { "g", group = "goto" },
                { "z", group = "fold" },
                { "gs", group = "surround" },
                { "gx", desc = "Open with system app" },
                {
                    "<leader>w",
                    group = "windows",
                    expand = function()
                        return require("which-key.extras").expand.win()
                    end,
                },
                {
                    "<leader>b",
                    group = "buffer",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end,
                },
            },
            icons = {
                mappings = false,
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            },
            plugins = {
                marks = true, -- ' 或 ` 显示 marks 列表
                registers = true, -- NORMAL 模式使用 ” 显示寄存器中的复制内容
                spelling = {
                    enabled = true, -- 按下 z= 显示拼写检查列表
                    suggestions = 20, -- 列表长度
                },
                presets = {
                    operators = true, -- 显示操作符帮助，如 d,y,c 等
                    motions = true, -- 显示移动操作帮助
                    text_objects = true, -- 显示文本对象帮助，nvim 的 ai 操作
                    windows = true, -- 显示 Ctrl+w 相关的窗口操作快捷键
                    nav = true, -- 显示窗口导航相关的其他绑定
                    z = true, -- 显示 z 开头的快捷键
                    g = true, -- 显示 g 开头的快捷键
                },
            },
        },
    },
}
