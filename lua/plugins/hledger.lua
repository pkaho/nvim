-- hledger 记账: vim-ledger 语法/命令 + ledger 专属 lint 与 treesitter parser
-- (blink 的 omni 补全已并入 lsp.lua, conform 的 ledger 格式化已在 formatter.lua, 避免重复 spec)
return {
    -- vim-ledger: ledger/hledger 语法高亮、账户补全、LedgerAlign/LedgerSort 命令
    {
        "ledger/vim-ledger",
        version = false,
        ft = "ledger",
        init = function()
            vim.g.ledger_bin = "hledger"
            vim.g.ledger_fuzzy_account_completion = 1
            vim.g.ledger_date_format = "%Y-%m-%d"
            vim.g.ledger_align_at = 70
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
