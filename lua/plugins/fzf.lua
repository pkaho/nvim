return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader><space>", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find Files" },
    },
    opts = {},
}
