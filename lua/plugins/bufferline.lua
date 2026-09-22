return {
    -- bufferline: 顶部 buffer 标签栏
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            -- stylua: ignore start
            { "<leader>bb", "<cmd>e #<CR>",                              desc = "Switch to Other Buffer" },
            { "<leader>b`", "<cmd>e #<CR>",                              desc = "Switch to Other Buffer" },
            { "<leader>bd", function() Snacks.bufdelete() end,           desc = "Delete Buffer" },
            { "<leader>bo", function() Snacks.bufdelete.other() end,     desc = "Delete Other Buffers" },
            { "<leader>bi", function() Snacks.bufdelete.invisible() end, desc = "Delete Invisible Buffers" },
            { "<leader>ba", function() Snacks.bufdelete.all() end,       desc = "Delete All Buffers" },
            { "<leader>bD", "<cmd>:bd<CR>",                              desc = "Delete Buffer and Window" },
            { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",              desc = "Toggle Pin" },
            { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>",   desc = "Delete Non-Pinned Buffers" },
            { "<leader>br", "<cmd>BufferLineCloseRight<CR>",             desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>",              desc = "Delete Buffers to the Left" },
            { "<leader>bj", "<cmd>BufferLinePick<cr>",                   desc = "Pick Buffer" },
            { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",              desc = "Prev Buffer" },
            { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",              desc = "Next Buffer" },
            { "[b",         "<cmd>BufferLineCyclePrev<cr>",              desc = "Prev Buffer" },
            { "]b",         "<cmd>BufferLineCycleNext<cr>",              desc = "Next Buffer" },
            { "[B",         "<cmd>BufferLineMovePrev<cr>",               desc = "Move buffer prev" },
            { "]B",         "<cmd>BufferLineMoveNext<cr>",               desc = "Move buffer next" },
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
}
