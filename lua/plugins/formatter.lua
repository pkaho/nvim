return {
    -- conform: 统一格式化入口
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format Buffer",
            },
            {
                "<leader>cF",
                function()
                    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
                end,
                mode = { "n", "x" },
                desc = "Format Injected Langs",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_imports", "ruff_format" }, -- black 与 ruff_format 功能重叠（同为整段格式化），只保留 ruff_format：与 black 风格兼容且更快
                ledger = { "trim_newlines", "trim_whitespace" },

                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                markdown = { "prettier" },
                yaml = { "yamlfmt" },
                sh = { "shfmt" },
                bash = { "shfmt" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "spaces", "--indent-width", "4" },
                },
                -- ruff 专门处理 import 自动排序
                ruff_imports = {
                    command = "ruff",
                    args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
                },
                -- ruff 代码格式化
                ruff_format = {
                    command = "ruff",
                    args = { "format", "--stdin-filename", "$FILENAME", "-" },
                },
            },
            format_on_save = function(bufnr)
                -- 对没有良好编码风格标准的语言禁用 "format_on_save lsp_fallback"
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_fallback = true,
                    }
                end
            end,
        },
    },
}
