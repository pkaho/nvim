return {
    -- overseer: 任务运行器 (编译/测试/构建等命令的面板化管理, :h overseer)
    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerRun",
            "OverseerShell",
            "OverseerToggle",
            "OverseerTaskAction",
        },
        opts = {
            -- 默认任务策略: terminal 在终端里跑 (也可用 jobstart 后台跑)
            strategy = "terminal",
            -- 任务面板方向: left/right/bottom
            task_list = {
                direction = "right",
            },
        },
        keys = {
            { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run Task" },
            {
                "<leader>oR",
                function()
                    vim.ui.input({ prompt = "command", completion = "shellcmdline" }, function(cmd)
                        if cmd and cmd ~= "" then
                            local task_cmd
                            -- Windows 上用 pwsh 执行, 支持 ls/grep 等 Unix 习惯命令 (其他系统直接用原命令)
                            if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
                                task_cmd = { "pwsh", "-NoProfile", "-NoLogo", "-Command", cmd }
                            else
                                task_cmd = cmd
                            end
                            local task = require("overseer.task").new({ cmd = task_cmd })
                            task:start()
                        end
                    end)
                end,
                desc = "Run Shell Command (pwsh on Windows)",
            },
            { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "Toggle Task List" },
            { "<leader>oa", "<cmd>OverseerTaskAction<CR>", desc = "Task Action" },
        },
    },

    -- persistence: 自动保存/恢复会话
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>qS",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
}
