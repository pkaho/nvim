return {
    -- theme 选择器
    {
        "zaldih/themery.nvim",
        lazy = false,
        keys = {
            { "<leader>uc", "<cmd>Themery<cr>", desc = "Select Color Theme" }
        },
        opts = {
            themes = {"cyberdream", "rose-pine", "catppuccin"},
            livePreview = true,
        },
    },

    -- cyberdream
    {
        "scottmckendry/cyberdream.nvim",
        event = "VeryLazy",
        dependencies = {
            "mawkler/modicator.nvim",
            enabled = true,
        },
        lazy = false,
        priority = 1000,
        opts = {
            transparent = false,
            italic_comments = true,
            variant = "auto", -- default, auto, light
        },
    },

    -- rose-pine
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        opts = {},
        -- config = function()
        --     vim.cmd("colorscheme rose-pine")
        -- end
    },

    -- catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {},
    },
}
