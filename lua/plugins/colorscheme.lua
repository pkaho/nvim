return {
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
}
