return {
    -- vim-ledger: ledger/hledger 语法高亮、账户补全、LedgerAlign/LedgerSort 命令
    {
        "ledger/vim-ledger",
        version = false,
        ft = "ledger",
        init = function()
            vim.g.ledger_bin = "hledger"              -- 使用的记账可执行文件（hledger 而非 ledger）
            vim.g.ledger_fuzzy_account_completion = 1 -- 账户名模糊补全（配合 blink 的 omni 来源）
            vim.g.ledger_date_format = "%Y-%m-%d"     -- 日期补全格式
            vim.g.ledger_align_at = 70                -- LedgerAlign 对齐列位置
            -- 自定义 LedgerSort 命令：选中行排序（先按日期 hledger print 重排，再对齐）
            vim.cmd([[
                function LedgerSort() range
                    execute a:firstline .. ',' .. a:lastline .. '! hledger -f - -I print'
                    execute a:firstline .. ',' .. a:lastline .. 's/^    /  /g'
                    execute a:firstline .. ',' .. a:lastline .. 'LedgerAlign'
                endfunction
                command -range LedgerSort :<line1>,<line2>call LedgerSort()
            ]])
        end,
    },

    -- nvim-lint: 异步代码检查
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                fish = { "fish" },
                ledger = { "hledger" },
                python = { "ruff" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end
            })
        end,
    },
}
