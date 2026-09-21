return {
    -- mason: LSP 服务器 / 格式化 / 静态检查工具的安装与管理
    { "mason-org/mason.nvim", opts = {} },

    -- mason-lspconfig: 桥接 mason 与 nvim-lspconfig, 自动安装并启动
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            -- 首次启动自动安装的 LSP 服务器
            ensure_installed = {
                "lua_ls",
                "pyright",
            },
        },
    },

    -- blink.cmp: 补全引擎 (与 LSP capabilities 联动)
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            -- 国内网络下载 GitHub Releases 预编译模糊库不稳, 固定 Lua 实现 (功能等价, 免下载免警告)
            fuzzy = { implementation = "lua" }, -- prefer_rust / lua
            completion = { documentation = { auto_show = true } },
            appearance = { nerd_font_variant = "mono" },
            signature = { enabled = true },
            keymap = { preset = "default" },
            cmdline = {
                enabled = true,
                keymap = { preset = "cmdline" },
                completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                        auto_show = function(ctx)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    ghost_text = { enabled = true },
                },
            },
            sources = {
                -- omni: 使用 buffer 的 omnifunc (如 vim-ledger 提供的账户补全), 无自定义 omnifunc 时不生效
                default = { "lazydev", "lsp", "path", "snippets", "buffer", "omni" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            snippets = {
                expand = function(snippet)
                    vim.snippet.expand(snippet)
                end,
            },
        },
    },

    -- lazydev: 为 lua_ls 提供 Neovim API / lazy.nvim / luv 的类型与全局识别
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
            },
        },
    },

    -- glance: 像 vscode 一样预览 LSP 相关代码位置
    {
        "dnlhc/glance.nvim",
        -- 仅由 keys 懒加载（原先 lazy = false 会取消懒加载，导致启动即加载）
        keys = {
            { "<leader>cgd", "<CMD>Glance definitions<CR>", desc = "Glance Definition" },
            { "<leader>cgr", "<CMD>Glance references<CR>", desc = "Glance Reference" },
            { "<leader>cgy", "<CMD>Glance type_definitions<CR>", desc = "Glance Type Definition" },
            { "<leader>cgm", "<CMD>Glance implementations<CR>", desc = "Glance Implementation" },
        },
        opts = {},
    },

    -- nvim-lspconfig: LSP 客户端配置与 buffer 级按键
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "folke/lazydev.nvim",
        },
        config = function()
            -- LSP 附加到当前 buffer 时设置的按键 (buffer-local)
            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
                end

                -- 跳转
                map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("n", "gr", vim.lsp.buf.references, "Goto References")
                map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
                map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                map("n", "gO", vim.lsp.buf.document_symbol, "Document Symbol")

                -- 悬浮文档 / 签名
                map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

                -- hover/signature 浮窗内用 <c-f>/<c-b> 滚动, 无浮窗时回退默认翻页
                vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end, { buffer = bufnr, expr = true, silent = true, desc = "Scroll Float Forward" })
                vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end, { buffer = bufnr, expr = true, silent = true, desc = "Scroll Float Backward" })

                -- 重构
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>co", function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        context = { only = { "source.organizeImports" }, diagnostics = {} },
                    })
                end, "Organize Imports")
                map("n", "<leader>cR", "<CMD>LspRestart<CR>", "Restart LSP")
            end

            -- 诊断显示样式
            vim.diagnostic.config({
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                    source = "if_many",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    source = true,
                    border = "rounded",
                },
            })

            -- 由 blink.cmp 注入 LSP 补全 capabilities
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- nvim 0.11+ 原生 LSP 配置: 默认配置应用于所有服务器, lua_ls 单独覆盖
            -- (mason-lspconfig 的 automatic_enable 会自动 vim.lsp.enable() 已安装的服务器)
            vim.lsp.config("*", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" }, -- Neovim 内置 LuaJIT, 避免按 5.4 推断
                        telemetry = { enable = false },
                        diagnostics = {
                            -- LuaLS 3.9+ 不再默认把 require 视为全局, 需显式声明
                            globals = { "vim", "require" },
                        },
                    },
                },
            })
        end,
    },
}
