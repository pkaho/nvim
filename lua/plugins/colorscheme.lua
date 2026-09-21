return {
    -- themify: 主题管理器
    -- (键位用 <leader>uB: <leader>ub 已被 snacks 的 Dark Background toggle 占用)
    {
        "lmantw/themify.nvim",
        lazy = false,   -- 不设置懒加载，懒加载会导致主题不生效
        priority = 999, -- 保持优先级
        keys = {
            { "<leader>uB", "<CMD>Themify<CR>", desc = "Colorscheme Theme" }
        },
        opts = {
            "Shatur/neovim-ayu",
            "catppuccin/nvim",
            "kepano/flexoki-neovim",
            "rose-pine/neovim",
            "sainnhe/sonokai",
            "rebelot/kanagawa.nvim",
        }
    }
}
