return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        branch = "master",
        lazy = vim.fn.argc(-1) == 0, -- 如果没有打开文件则懒加载
        build = ":TSUpdate",
        -- init = function(plugin)
        --     -- 来源于lazyvim, 部分插件不再主动加载treesitter, 导致功能出问题
        --     -- 但实际上, 这些插件只用到了一小部分功能(比如自定义语法查询)
        --     -- 所以, 在neovim启动时, 提前准备好这一部分功能
        --     require("lazy.core.loader").add_to_rtp(plugin)
        --     require("nvim-treesitter.query_predicates")
        -- end,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<BS>", desc = "Decrement Selection", mode = "x" },
            { "<CR>", desc = "Increment Selection" },
        },
        opts = {
            folding = { enable = true },
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    node_decremental = '<BS>',
                    scope_incremental = '<TAB>',
                }
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
                }
            }
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

    {

    }
}
