return {
    -- 括号补全
    {
        "altermo/ultimate-autopair.nvim",
        event = {"InsertEnter", "CmdlineEnter"},
        opts = {},
    },

    -- 扩展并创建a/i文本对象
    {
        "echasnovski/mini.ai",
        version = false,
        opts = {}
    },

    -- 环绕操作(增删改查/高亮括号、引号等)
    {
        "echasnovski/mini.surround",
        version = false,
        opts = {
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",

                suffix_last = "l",
                suffix_next = "n"
            }
        }
    },

    -- 预览命令行输入的行号处的内容
    {
        "nacro90/numb.nvim",
        event = "VeryLazy",
        opts = {
            show_numbers = true,
            show_cursorline = true,
        }
    },

    -- 交互式对齐文本
    {
        "echasnovski/mini.align",
        version = false,
        opts = {}
    },

    -- 拆分/合并代码块(数组、哈希、语句、对象等)
    {
        "Wansmer/treesj",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            { "<leader>cj", "<CMD>TSJToggle<CR>", desc = "Treesj Toggle" },
        },
        opts = {
            use_default_keymaps = false,
        }
    },
}
