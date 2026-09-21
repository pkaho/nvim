-- nvim-treesitter 与 textobjects: 语法高亮 / 增量选择 / 文本对象查询
return {
    -- nvim-treesitter: 语法高亮 / 增量选择 / 缩进
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        opts = {
            indent = { enable = true },
            highlight = { enable = true },
            folds = { enable = true },
            ensure_installed = {
                "vim",
                "lua",
                "python",
                "ledger",
                -- "vimdoc",
                -- "query",
                -- "c",
                -- "markdown",
                -- "markdown_inline",
                -- "bash",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                },
            },
        },
    },

    -- nvim-treesitter-textobjects: 提供 block/function/class 等 textobjects 查询
    -- 供 mini.ai 的 o/f/c 自定义文本对象使用 (mini.lua 中声明了该依赖)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
