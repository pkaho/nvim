return {
    -- multicursor.nvim: 多光标编辑
    -- 官方文档: :h multicursor
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        event = "VeryLazy",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local map = vim.keymap.set

            -- stylua: ignore start
            -- 在当前光标上方/下方添加光标, 或跳过该行
            -- 注: <Up>/<Down> 已被 keybinds.lua 映射为 gj/gk (wrap 续行移动),
            --     <C-Up>/<C-Down> 被用于窗口缩放, 故行添加光标改用 <M-Up>/<M-Down>
            map({ "n", "x" }, "<M-Up>", function() mc.lineAddCursor(-1) end)
            map({ "n", "x" }, "<M-Down>", function() mc.lineAddCursor(1) end)
            map({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
            map({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

            -- 向前/向后匹配当前单词或选区, 添加或跳过光标
            -- 注: 官方示例跳过匹配用 <leader>s/S, 与 which-key 的 search 组冲突, 改用 <leader>j/J
            map({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
            map({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
            map({ "n", "x" }, "<leader>j", function() mc.matchSkipCursor(1) end)
            map({ "n", "x" }, "<leader>J", function() mc.matchSkipCursor(-1) end)
            -- stylua: ignore end

            -- 添加所有匹配: 一次给文档中所有匹配单词加光标
            map({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

            -- Ctrl + 鼠标左键 添加/移除光标
            map("n", "<C-leftmouse>", mc.handleMouse)
            map("n", "<C-leftdrag>", mc.handleMouseDrag)
            map("n", "<C-leftrelease>", mc.handleMouseRelease)

            -- Ctrl-q 切换光标开关
            map({ "n", "x" }, "<C-q>", mc.toggleCursor)

            -- 以下映射只在存在多个光标时生效 (keymap layer)
            mc.addKeymapLayer(function(layerSet)
                -- 切换主光标
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- 删除主光标 (官方示例 <leader>x 与 trouble 的 diagnostics 组冲突, 改用 <leader>d)
                layerSet({ "n", "x" }, "<leader>d", mc.deleteCursor)

                -- Esc: 有光标时先启用, 再次按清除所有光标
                layerSet("n", "<esc>", function()
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
