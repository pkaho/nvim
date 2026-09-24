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
            default_format_opts = {
                timeout_ms = 3000,
                async = false,
                quiet = false,
                lsp_format = "fallback",
            },
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
                injected = { options = { ignore_errors = true } },
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

    -- vim-ledger: ledger/hledger 语法高亮、账户补全、LedgerAlign/LedgerSort 命令
    {
        "ledger/vim-ledger",
        version = false,
        ft = "ledger",
        init = function()
            vim.g.ledger_bin = "hledger" -- 使用的记账可执行文件（hledger 而非 ledger）
            vim.g.ledger_fuzzy_account_completion = 1 -- 账户名模糊补全（配合 blink 的 omni 来源）
            vim.g.ledger_date_format = "%Y-%m-%d" -- 日期补全格式
            vim.g.ledger_align_at = 70 -- LedgerAlign 对齐列位置
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

    -- render-markdown: markdown 预览
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "md",
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
            checkbox = {
                enabled = false,
            },
        },
    },

    -- nvim-lint: 异步代码检查（独立配置，不依赖 LazyVim；通知由 noice 接管渲染）
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost", "InsertLeave" },
        -- 配置声明区：后期加 linter / 改触发时机 / 自定义 linter 都只改这里
        opts = {
            events = { "BufEnter", "BufWritePost", "InsertLeave" },
            linters_by_ft = {
                fish = { "fish" },
                ledger = { "hledger" },
                python = { "ruff" },
            },
            -- 自定义/覆盖 linter 行为（命令、参数、条件）。留空表即可
            -- 例：linters = { ruff = { prepend_args = { "--ignore", "E501" } } }
            linters = {},
        },
        config = function(_, opts)
            opts = opts or {}
            local lint = require("lint")

            -- 合并自定义 linter 定义：深合并覆盖内置定义，prepend_args 前置插入参数
            for name, linter in pairs(opts.linters) do
                local base = lint.linters[name]
                if type(linter) == "table" and type(base) == "table" then
                    ---@type lint.Linter
                    local merged = vim.tbl_deep_extend("force", base, linter)
                    lint.linters[name] = merged
                    if type(linter.prepend_args) == "table" then
                        merged.args = merged.args or {}
                        for i = #linter.prepend_args, 1, -1 do
                            table.insert(merged.args, 1, linter.prepend_args[i])
                        end
                    end
                else
                    lint.linters[name] = linter
                end
            end
            lint.linters_by_ft = opts.linters_by_ft

            -- 解析当前 buffer 应运行的 linter 列表：
            -- * 优先按完整 filetype 匹配；无匹配时按 "." 拆分追加
            -- * 仍无匹配时使用 "_" 兜底，最后追加 "*" 全局 linter
            -- * 过滤未注册或 condition 不满足的 linter
            local function resolve_linters()
                local names = lint._resolve_linter_by_ft(vim.bo.filetype)
                names = vim.list_extend({}, names)
                if #names == 0 then
                    vim.list_extend(names, lint.linters_by_ft["_"] or {})
                end
                vim.list_extend(names, lint.linters_by_ft["*"] or {})

                local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

                return vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    if not linter then
                        -- vim 原生通知；noice 已接管消息渲染
                        vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
                        return false
                    end
                    if type(linter) == "table" then
                        -- condition 是 LazyVim 约定的扩展字段，nvim-lint 类型注解未收录
                        ---@diagnostic disable-next-line: undefined-field
                        if linter.condition and not linter.condition(ctx) then
                            return false
                        end
                    end
                    return true
                end, names)
            end

            -- 原生防抖：连续事件（如保存+离开插入模式）在 100ms 内只触发一次
            local function debounce(ms, fn)
                local timer = assert(vim.uv.new_timer())
                return function(...)
                    local argv = { ... }
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            local run_lint = debounce(100, function()
                local names = resolve_linters()
                if #names > 0 then
                    lint.try_lint(names)
                end
            end)

            -- 单个 autocmd 注册；事件来源为 opts.events
            vim.api.nvim_create_autocmd(opts.events, {
                group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                callback = run_lint,
            })

            -- 手动触发检查
            vim.keymap.set("n", "<leader>l", function()
                lint.try_lint()
            end, { desc = "Trigger Lint" })
        end,
    },

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
