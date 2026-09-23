return {
    -- nvim-treesitter: parser 安装与更新
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        -- 安装/更新插件时同步安装非内置 parser (TSInstall 为异步任务, 轮询等待完成; 已装的自动跳过)
        build = function()
            local langs = { "python", "ledger", "diff", "regex" }
            local function missing()
                local miss = {}
                for _, l in ipairs(langs) do
                    if not vim.uv.fs_stat(vim.fn.stdpath("data") .. "/site/parser/" .. l .. ".so") then
                        table.insert(miss, l)
                    end
                end
                return miss
            end
            local miss = missing()
            if #miss > 0 then
                vim.cmd("TSInstall " .. table.concat(miss, " "))
                vim.wait(300000, function()
                    return #missing() == 0
                end, 2000)
            end
        end,
        opts = {
            install_dir = vim.fn.stdpath("data") .. "/site",
        },
    },

    -- nvim-treesitter-textobjects: ]f/]c/]a 按语法结构跳转 (函数/类/参数)
    -- set_jumps = true 是默认值: 跳转写入 jumplist, <C-o> 可返回
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            -- 函数跳转
            {
                "]f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                desc = "Next Function Start",
            },
            {
                "]F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                end,
                desc = "Next Function End",
            },
            {
                "[f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                desc = "Prev Function Start",
            },
            {
                "[F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                desc = "Prev Function End",
            },
            -- 类跳转
            {
                "]c",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
                end,
                desc = "Next Class Start",
            },
            {
                "]C",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
                end,
                desc = "Next Class End",
            },
            {
                "[c",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                end,
                desc = "Prev Class Start",
            },
            {
                "[C",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
                end,
                desc = "Prev Class End",
            },
            -- 参数跳转
            {
                "]a",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
                end,
                desc = "Next Parameter",
            },
            {
                "]A",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.inner", "textobjects")
                end,
                desc = "Next Parameter End",
            },
            {
                "[a",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
                end,
                desc = "Prev Parameter",
            },
            {
                "[A",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.inner", "textobjects")
                end,
                desc = "Prev Parameter End",
            },
        },
    },

    -- nvim-treesitter-context: 屏幕顶部固定显示当前所在函数/类的上下文
    -- (未绑定 [q 跳转上下文: 该键已被 trouble.nvim 占用, 避免冲突)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = function()
            local tsc = require("treesitter-context")
            Snacks.toggle({
                name = "Treesitter Context",
                get = tsc.enabled,
                set = function(state)
                    if state then
                        tsc.enable()
                    else
                        tsc.disable()
                    end
                end,
            }):map("<leader>ut")
            return { mode = "cursor", max_lines = 3 }
        end,
    },
}
