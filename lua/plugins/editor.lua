return {
    -- 快捷键提示
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = {"spec"},
        opts = {
            preset = "helix", -- classic, modern, helix
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "gs", group = "surround" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            }
        }
    },

    -- easymotion
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- 颜色可视化
    {
        "norcalli/nvim-colorizer.lua",
        opts = { "*" },
    },

    -- 颜色选择器
    {
        "uga-rosa/ccc.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader>cp", "<CMD>CccPick<CR>", desc = "ColorPick" },
        }
    },

    -- git
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<CMD>LazyGit<CR>", desc = "LazyGit" }
        },
    },

    -- 数字增量
    -- {
    --     "monaqa/dial.nvim",
    --     event = "VeryLazy",
    --     opts = {}
    -- }
}
