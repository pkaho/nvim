return {
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

    -- :line num，查看行号内容
    {
        "nacro90/numb.nvim",
        event = "VeryLazy",
        opts = {
            show_numbers = true,
            show_cursorline = true,
        }
    },

    -- 颜色可视化和选择器
    {
        "norcalli/nvim-colorizer.lua",
        opts = { "*" },
    },
    {
        "uga-rosa/ccc.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader>cp", "<CMD>CccPick<CR>", desc = "ColorPick" },
        }
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        }
    },

    {
        "monaqa/dial.nvim",
        event = "VeryLazy",
    },

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
        opts = {}
    },
}
