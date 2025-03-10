return {
    -- https://github.com/ibhagwan/fzf-lua
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        { "<leader><space>", "<CMD>lua require('fzf-lua').files()<CR>", desc = "Find Files" }
    },
}
