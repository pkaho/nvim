return {
    -- ultimate-autopair: 自动配对/补全括号引号
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            pair_cmap = false, -- 命令行补全
        },
    },

    -- treesj: 拆分/合并代码块
    {
        "Wansmer/treesj",
        cmd = "TSJToggle",
        opts = {
            use_default_keymaps = false, -- 关闭默认按键, 统一用 <leader>cj 切换
        },
        keys = {
            { "<leader>cj", "<cmd>TSJToggle<CR>", desc = "Split/Join Bracketed" },
        },
    },

    -- numb: 跳转行号时预览该位置内容
    {
        "nacro90/numb.nvim",
        event = "CmdlineEnter", -- 仅在输入命令行时加载
        opts = {
            show_numbers = true,
            show_cursorline = true,
        }
    },

    -- range-highlight: 高亮命令模式选中的文本范围
    {
        "winston0410/range-highlight.nvim",
        event = "VeryLazy",
        opts = {}
    },

    -- comfy-line-numbers: 左手完成[n]操作
    {
        "mluders/comfy-line-numbers.nvim",
        lazy = false, -- 行号渲染需启动时生效, 插件很小不影响启动速度
        opts = {}
    },
}
