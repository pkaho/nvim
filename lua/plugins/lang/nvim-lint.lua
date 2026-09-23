return {
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
}
