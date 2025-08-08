local opts = function (buf, content)
    return { buffer = buf, desc = content }
end
return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            vim.lsp.enable("pyright")
            vim.lsp.enable("lua_ls")

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local buf = args.buf
                    -- 按键映射
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts(buf, "Goto Definition"))
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts(buf, "Goto Declaration"))
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts(buf, "Hover"))
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
