return {
    -- nvim-colorizer: 高亮文件中的颜色代码
    {
        "catgoose/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" }, -- 打开文件时才高亮颜色
        opts = {}
    },

    -- ccc: 交互式颜色选择器
    -- (键位用 <leader>uC: <leader>uc 已被 snacks 的 Conceal Level toggle 占用)
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        keys = {
            { "<leader>uC", "<CMD>CccPick<CR>", desc = "Color Pick (ccc)" }
        },
        opts = {},
    },
}
