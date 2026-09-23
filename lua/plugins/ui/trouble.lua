return {
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
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<CR>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
                desc = "LSP Refs / Defs (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<CR>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<CR>",
                desc = "Quickfix List (Trouble)",
            },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
}
