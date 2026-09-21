-- 颜色工具: 颜色代码高亮 / 交互式取色
return {
    -- nvim-colorizer: 高亮文件中的颜色代码 (#hex/rgb/hsl 等)
    {
        "catgoose/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" }, -- 打开文件时才高亮颜色
        opts = {}
    },

    -- ccc: 交互式颜色选择器 (c 前缀留给 code, 放到 ui 组 <leader>uc)
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        keys = {
            { "<leader>uc", "<CMD>CccPick<CR>", desc = "Color Pick (ccc)" }
        },
        opts = {},
    },
}
