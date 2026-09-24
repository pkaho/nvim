-- todo-comments：Snacks picker 封装（todo_fn：只关注指定关键词）
local function todo_fn(filtered)
    local todo_keys = { "TODO", "FIX", "FIXME" } -- 只关注指定的关键词列表
    return function()
        local opts = filtered and { keywords = todo_keys } or nil
        Snacks.picker.todo_comments(opts)
    end
end

return {
    -- flash: 快速跳转
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            -- stylua: ignore start
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
            { "<C-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            -- stylua: ignore end
            {
                "<C-Space>",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter({
                        actions = {
                            ["<C-space>"] = "next",
                            ["<BS>"] = "prev",
                        },
                    })
                end,
                desc = "Treesitter Incremental Selection",
            },
        },
    },

    -- grug-far: 跨文件全局搜索与替换
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
            },
        },
        opts = { headerMaxWidth = 80 },
    },

    -- todo-comments: 高亮并跳转 TODO/FIXME/NOTE 等注释
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TodoTrouble" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            -- stylua: ignore start
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },
            { "<leader>xt", "<CMD>Trouble todo toggle<CR>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<CMD>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", todo_fn(), desc = "Search Todo" },
            { "<leader>sT", todo_fn(true), desc = "Todo/Fix/Fixme" },
            -- stylua: ignore end
        },
    },
}
