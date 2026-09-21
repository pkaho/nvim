-- 编辑增强: 自动配对 / 拆合代码块 / 行号美化 / 选中范围高亮
return {
    -- ultimate-autopair: 自动配对/补全括号引号 (insert 与命令行模式)
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            pair_cmap = false, -- 命令行补全
        },
    },

    -- treesj: 拆分/合并代码块 (单行展开多行/多行折叠单行, <leader>cj 切换)
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

    -- numb: 跳转行号时浮动显示目标行号 (可点击跳转)
    {
        "nacro90/numb.nvim",
        event = "CmdlineEnter", -- 仅在输入命令行时加载
        opts = {
            show_numbers = true,
            show_cursorline = true,
        }
    },

    -- range-highlight: 高亮视觉/操作符模式选中的文本范围
    {
        "winston0410/range-highlight.nvim",
        event = "VeryLazy",
        opts = {}
    },

    -- comfy-line-numbers: 美化行号 (基于相对行号的渐变/自定义样式)
    {
        "mluders/comfy-line-numbers.nvim",
        lazy = false, -- 行号渲染需启动时生效, 插件很小不影响启动速度
        opts = {}
    },
}
