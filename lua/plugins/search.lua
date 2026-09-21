-- 搜索替换: 跨文件全局搜索与替换
-- (文件搜索 / grep 类 picker 在 snacks.lua 中, 快速跳转在 flash.lua 中)
return {
    -- grug-far: 跨文件全局搜索与替换 (<leader>sr)
    {
        "MagicDuck/grug-far.nvim",
        cmd = { "GrugFar", "GrugFarWithin" },
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
                    })
                end,
                mode = { "n", "x" },
                desc = "Search and Replace",
            }
        },
        opts = { headerMaxWidth = 80 },
    },
}
