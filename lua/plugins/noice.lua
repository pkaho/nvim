-- noice: 美化 cmdline / 消息 / popupmenu, 接管 vim.notify
-- 注意: 与 snacks.notifier 冲突, 已在 snacks.lua 中禁用后者
return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = {
            { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end,    desc = "Noice Picker" },
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                desc = "Redirect Cmdline",
                mode = "c"
            },
            -- <c-f>/<c-b> 滚动 LSP 浮窗的映射由 lsp.lua 的 on_attach 按 buffer 绑定（仅 LSP attach 后生效），这里不再全局定义
        },
        opts = {
            messages = {
                enabled = true,
                view = "mini",
                view_error = "mini",
                view_warn = "mini",
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
            },
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
        end
    },
}
