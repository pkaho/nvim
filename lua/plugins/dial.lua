--[[
dial.nvim：<C-a> / <C-x> 递增 / 递减光标下的数字、日期、布尔、常量等
====================================================================

【核心概念】
  augend          一种"可递增的原子"：十进制数、十六进制数、日期、布尔值、自定义常量表……
  group           一组 augend 的集合，按名称注册（dial.nvim 原生概念，default 为兜底组）
  filetype 分组   dial.nvim 原生机制：注册"文件类型 → augend 列表"后自动生效；
                  未映射的文件类型回退到 default 组（无需运行时查表）

【键位】（均支持 count，如 3<C-a> = 连续递增 3 次）
  <C-a>           递增（normal / visual 通用，visual 下只改选中区域）
  <C-x>           递减
  g<C-a>          g 操作符版递增：作用于 motion 范围，如 g<C-a>w 递增一个单词
  g<C-x>          g 操作符版递减

【文件类型分组策略】
  每种文件类型的有效递增类型 = 专属 augend ∪ default 公共基线
  （如 typescript 文件 = let/const 专属 + 所有公共类型）

【如何扩展】
  1. 所有文件都想要一种新递增类型  → 往 default_augends 加一行
  2. 某文件类型加专属类型          → 往对应 xxx_augends 加一行
  3. 新增文件类型映射              → 在 on_filetype 的表里加一行（可共享同一张表）
  4. 改触发键位                    → 改 keys 表
--]]

-- expr keymap 回调：按键时求值，返回 dial 的按键序列字符串（<Cmd>...<CR>）
-- increment: true=递增 false=递减；operator: 是否为 g 操作符版（作用于 motion）
local function dial_rhs(increment, operator)
    local mode = vim.fn.mode(true)
    -- v: 字符选区  V: 行选区  <C-v>: 块选区
    local is_visual = mode:match("^[vV]") or mode == vim.api.nvim_replace_termcodes("<C-v>", true, false, true)
    -- 拼出 dial.map 的方法名：inc/dec + [_g][visual|normal]
    local name = (increment and "inc" or "dec") .. (operator and "_g" or "_") .. (is_visual and "visual" or "normal")
    return require("dial.map")[name]()
end

return {
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

            -- 各文件类型的专属 augend
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

            -- 文件类型映射：专属 ∪ 公共基线（与默认行为保持一致）
            -- 共享表引用：sass/scss 复用 css，js/ts 系列复用 typescript
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
}
