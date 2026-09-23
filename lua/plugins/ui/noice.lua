return {
    -- noice: 消息通知工具
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = {
            {
                "<leader>snl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            {
                "<leader>snh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            {
                "<leader>sna",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            {
                "<leader>snd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
            {
                "<leader>snt",
                function()
                    require("noice").cmd("pick")
                end,
                desc = "Noice Picker",
            },
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                desc = "Redirect Cmdline",
                mode = "c",
            },
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
}
