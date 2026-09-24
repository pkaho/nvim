local function dial_rhs(increment, operator)
    local mode = vim.fn.mode(true)
    -- v: 字符选区  V: 行选区  <C-v>: 块选区
    local is_visual = mode:match("^[vV]") or mode == vim.api.nvim_replace_termcodes("<C-v>", true, false, true)
    -- 拼出 dial.map 的方法名：inc/dec + [_g][visual|normal]
    local name = (increment and "inc" or "dec") .. (operator and "_g" or "_") .. (is_visual and "visual" or "normal")
    return require("dial.map")[name]()
end

return {
    -- dial.nvim
    {
        "monaqa/dial.nvim",
        keys = {
            -- stylua: ignore start
            { "<C-a>", function() return dial_rhs(true) end, expr = true, desc = "Increment", mode = { "n", "v" } },
            { "<C-x>", function() return dial_rhs(false) end, expr = true, desc = "Decrement", mode = { "n", "v" } },
            { "g<C-a>", function() return dial_rhs(true, true) end, expr = true, desc = "Increment (motion)", mode = { "n", "x" } },
            { "g<C-x>", function() return dial_rhs(false, true) end, expr = true, desc = "Decrement (motion)", mode = { "n", "x" } },
            -- stylua: ignore end
        },
        config = function()
            local augend = require("dial.augend")
            local augends = require("dial.config").augends

            -- 公共基线：所有文件类型都可用的递增类型
            local default_augends = {
                augend.integer.alias.decimal, -- 非负十进制 (0, 1, 2, ...)
                augend.integer.alias.decimal_int, -- 可负十进制
                augend.integer.alias.hex, -- 十六进制 (0x01, 0x1a1f, ...)
                augend.date.alias["%Y/%m/%d"], -- 日期 (2026/09/22)
                augend.constant.alias.en_weekday, -- 星期缩写 (Mon, Tue, ...)
                augend.constant.alias.en_weekday_full, -- 星期全称 (Monday, ...)
                augend.constant.new({ -- 序数词 (first → tenth 循环)
                    elements = {
                        "first",
                        "second",
                        "third",
                        "fourth",
                        "fifth",
                        "sixth",
                        "seventh",
                        "eighth",
                        "ninth",
                        "tenth",
                    },
                    word = false,
                    cyclic = true,
                }),
                augend.constant.new({ -- 月份全称 (January → December 循环)
                    elements = {
                        "January",
                        "February",
                        "March",
                        "April",
                        "May",
                        "June",
                        "July",
                        "August",
                        "September",
                        "October",
                        "November",
                        "December",
                    },
                    word = true,
                    cyclic = true,
                }),
                augend.constant.alias.bool, -- 小写布尔 (true ↔ false)
                augend.constant.alias.Bool, -- 大写布尔 (True ↔ False)
                augend.constant.new({ -- 逻辑运算符 (&& ↔ ||)
                    elements = { "&&", "||" },
                    word = false,
                    cyclic = true,
                }),
            }

            -- 各文件类型的专属 augend（有效类型 = 专属 ∪ 公共基线）
            local vue_augends = {
                augend.constant.new({ elements = { "let", "const" } }),
                augend.hexcolor.new({ case = "lower" }),
                augend.hexcolor.new({ case = "upper" }),
            }
            local ts_augends = {
                augend.constant.new({ elements = { "let", "const" } }),
            }
            local css_augends = {
                augend.hexcolor.new({ case = "lower" }),
                augend.hexcolor.new({ case = "upper" }),
            }
            local markdown_augends = {
                augend.constant.new({ -- 任务清单勾选状态 ([ ] ↔ [x])
                    elements = { "[ ]", "[x]" },
                    word = false,
                    cyclic = true,
                }),
                augend.misc.alias.markdown_header, -- Markdown 标题级别 (#, ##, ...)
            }
            local json_augends = {
                augend.semver.alias.semver, -- 语义化版本 (v1.1.2)
            }
            local lua_augends = {
                augend.constant.new({
                    elements = { "and", "or" },
                    word = true, -- word=false 时 "sand" 会变成 "sor"
                    cyclic = true,
                }),
            }
            local python_augends = {
                augend.constant.new({ elements = { "and", "or" } }),
            }

            -- 注册 default 组（filetype 未映射时的兜底）
            augends:register_group({ default = default_augends })

            -- 文件类型映射：sass/scss 复用 css，js/ts 系列复用 typescript（共享表引用）
            local function with_default(augs)
                vim.list_extend(augs, default_augends)
                return augs
            end

            local css_full = with_default(css_augends)
            local ts_full = with_default(ts_augends)
            augends:on_filetype({
                vue = with_default(vue_augends),
                typescript = ts_full,
                typescriptreact = ts_full,
                javascript = ts_full,
                javascriptreact = ts_full,
                css = css_full,
                sass = css_full,
                scss = css_full,
                markdown = with_default(markdown_augends),
                json = with_default(json_augends),
                lua = with_default(lua_augends),
                python = with_default(python_augends),
            })
        end,
    },

    -- ultimate-autopair: 自动配对/补全括号引号
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            pair_cmap = false, -- 命令行补全
        },
    },

    -- treesj: 拆分/合并代码块
    {
        "Wansmer/treesj",
        cmd = "TSJToggle",
        opts = {
            use_default_keymaps = false, -- 关闭默认按键, 统一用 <leader>cj 切换
        },
        keys = {
            { "<leader>cj", "<cmd>TSJToggle<CR>", desc = "Split/Join Bracketed" },
        },
    },

    -- numb: 跳转行号时预览该位置内容
    {
        "nacro90/numb.nvim",
        event = "CmdlineEnter", -- 仅在输入命令行时加载
        opts = {
            show_numbers = true,
            show_cursorline = true,
        },
    },

    -- range-highlight: 高亮命令模式选中的文本范围
    {
        "winston0410/range-highlight.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- comfy-line-numbers: 左手完成[n]操作
    {
        "mluders/comfy-line-numbers.nvim",
        lazy = false, -- 行号渲染需启动时生效, 插件很小不影响启动速度
        opts = {},
    },

    -- multicursor.nvim: 多光标编辑（官方文档: :h multicursor）
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        event = "VeryLazy",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local map = vim.keymap.set

            -- stylua: ignore start
            -- 多光标键位统一在 <leader>m 组 (which-key 显示为 "multi-cursor")
            -- 行光标: k/j = 上/下 (vim 方向), 大写 = 跳过该行
            -- 注: 不用 <M-Up>/<M-Down>, 因为 <Up>/<Down> 已被 keybinds.lua 映射为 gj/gk,
            --     <C-Up>/<C-Down> 被用于窗口缩放
            map({ "n", "x" }, "<leader>mk", function() mc.lineAddCursor(-1) end, { desc = "Add Cursor Above" })
            map({ "n", "x" }, "<leader>mj", function() mc.lineAddCursor(1) end, { desc = "Add Cursor Below" })
            map({ "n", "x" }, "<leader>mK", function() mc.lineSkipCursor(-1) end, { desc = "Skip Cursor Above" })
            map({ "n", "x" }, "<leader>mJ", function() mc.lineSkipCursor(1) end, { desc = "Skip Cursor Below" })

            -- 匹配当前单词或选区: n/N = 向后/向前添加光标, s/S = 跳过匹配
            -- 注: 官方示例跳过匹配用 <leader>s/S, 与 which-key 的 search 组冲突
            map({ "n", "x" }, "<leader>mn", function() mc.matchAddCursor(1) end, { desc = "Add Cursor Next Match" })
            map({ "n", "x" }, "<leader>mN", function() mc.matchAddCursor(-1) end, { desc = "Add Cursor Prev Match" })
            map({ "n", "x" }, "<leader>ms", function() mc.matchSkipCursor(1) end, { desc = "Skip Next Match" })
            map({ "n", "x" }, "<leader>mS", function() mc.matchSkipCursor(-1) end, { desc = "Skip Prev Match" })
            -- stylua: ignore end

            -- 添加所有匹配: 一次给文档中所有匹配单词加光标
            map({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Add Cursors to All Matches" })

            -- Ctrl + 鼠标左键 添加/移除光标
            map({ "n" }, "<C-leftmouse>", mc.handleMouse, { desc = "Add/Remove Cursor (mouse)" })
            map({ "n" }, "<C-leftdrag>", mc.handleMouseDrag, { desc = "Add Cursor Drag (mouse)" })
            map({ "n" }, "<C-leftrelease>", mc.handleMouseRelease, { desc = "Release Mouse Cursor" })

            -- Ctrl-q 切换光标开关
            map({ "n", "x" }, "<C-q>", mc.toggleCursor, { desc = "Toggle Cursors" })

            -- 以下映射只在存在多个光标时生效 (keymap layer)
            mc.addKeymapLayer(function(layerSet)
                -- 切换主光标
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- 删除主光标 (官方示例 <leader>x 与 trouble 的 diagnostics 组冲突, 归入 <leader>m 组)
                layerSet({ "n", "x" }, "<leader>md", mc.deleteCursor)

                -- Esc: 有光标时先启用, 再次按清除所有光标
                layerSet({ "n" }, "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- 自定义光标外观
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
    },
}
