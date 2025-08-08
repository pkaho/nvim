return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader><space>", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find Files" },
        { "<leader>sb", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Find Files" },
        { "<leader>H", "<cmd>lua require('fzf-lua').help_tags()<cr>" },
    },
    opts = {},
}
