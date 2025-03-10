return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
        { "<leader>bp", "<CMD>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
        { "<leader>bP", "<CMD>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
        { "<leader>br", "<CMD>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
        { "<leader>bl", "<CMD>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
        { "<S-h>", "<CMD>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
        { "<S-l>", "<CMD>BufferLineCycleNext<CR>", desc = "Next Buffer" },
        { "[b", "<CMD>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
        { "]b", "<CMD>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    },
}
