return {
    -- todo-comments: 高亮并跳转 TODO/FIXME/NOTE 等注释
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TodoTrouble", "TodoTelescope" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            -- stylua: ignore start
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
            -- stylua: ignore end
        },
    },
}
