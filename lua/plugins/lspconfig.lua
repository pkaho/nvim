local opts = function (buf, content)
    return { buffer = buf, desc = content }
end

return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            local fzf = require("fzf-lua")

            vim.lsp.enable("pyright")
            vim.lsp.enable("lua_ls")

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local buf = args.buf

                    vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,     opts(buf, "Goto Declaration"))
                    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,      opts(buf, "Reference"))
                    vim.keymap.set('n', 'gI',         vim.lsp.buf.implementation,  opts(buf, "Goto Implementation"))
                    vim.keymap.set('n', 'gy',         vim.lsp.buf.type_definition, opts(buf, "Goto T[y]pe Definition"))
                    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,           opts(buf, "Hover"))
                    vim.keymap.set('n', 'gK',         vim.lsp.buf.signature_help,  opts(buf, "signatureHelp"))
                    vim.keymap.set('i', '<c-k>',      vim.lsp.buf.signature_help,  opts(buf, "signatureHelp"))
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,     opts(buf, "Code Action"))
                    vim.keymap.set('n', '<leader>cc', vim.lsp.codelens.run,        opts(buf, "Run Codelens"))
                    vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh,    opts(buf, "Refresh & Display"))
                    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename,          opts(buf, "Rename"))
                end
            })
        end,
    },

    -- mason
    { "mason-org/mason.nvim", opts = {} },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
            },
        },
    },
}
