local function ai_buffer(ai_type)
    local start_line, end_line = 1, vim.fn.line("$")
    if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
    end

    local to_col = math.max(vim.fn.getline(end_line):len(), 1)
    return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

return {
    -- mini.ai: 增强文本对象 (af/if/aa/ia 等, 更智能地选函数/括号/条件)
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        -- 用函数延迟求值 opts: 插件加载时才 require mini.ai, 不破坏 lazy 加载
        opts = function()
            local mini_ai = require("mini.ai")
            return {
                n_lines = 500,
                -- 自定义文本对象，依赖 nvim-treesitter-textobjects
                custom_textobjects = {
                    -- 代码块对象（块、条件语句、循环）
                    o = mini_ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    -- 函数对象
                    f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    -- 类对象
                    c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    -- HTML/XML 标签对象
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                    -- 纯数字
                    d = { "%f[%d]%d+" },
                    -- 区分大小写的单词（驼峰/普通单词文本对象）
                    e = {
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    -- 选中整个 buffer 内容
                    g = ai_buffer,
                    -- 函数调用（包含带命名空间 a.b.func()），u = Usage 调用
                    u = mini_ai.gen_spec.function_call(),
                    -- 纯函数调用，函数名不允许带 . 点（只匹配 func()，不匹配 obj.func()）
                    U = mini_ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
                },
            }
        end,
    },

    -- mini.align: 按列对齐 (ga 开始, gA 带实时预览)
    {
        "echasnovski/mini.align",
        event = "VeryLazy",
        opts = {},
    },

    -- mini.surround: 围绕现有内容加/改/删括号引号
    -- 前缀改为 gs*, 避免与 flash.nvim 占用的 s 冲突
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {
            mappings = {
                add = "gsa",            -- 添加 surround, 如 gsa) 括号包当前词
                delete = "gsd",         -- 删除 surround
                find = "gsf",           -- 向右查找 surround
                find_left = "gsF",      -- 向左查找 surround
                highlight = "gsh",      -- 高亮当前 surround
                replace = "gsr",        -- 替换 surround, 如 gsr)"
                update_n_lines = "gsn", -- 修改底部显示行数
                suffix_last = "l",      -- 同类型多个 surround 时, 选择最后一个
                suffix_next = "n",      -- 同类型多个 surround 时, 选择下一个
            },
        },
    },
}
