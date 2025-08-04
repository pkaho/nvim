return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
        { "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" } },
        { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
        { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
        { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
        { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
        { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
}
