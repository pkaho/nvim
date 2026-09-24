--                                                *map-table*
--  Mode | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- ------+------+-----+-----+-----+-----+-----+------+------+
--   n   | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--   !   |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--   i   |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--   c   |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--   v   |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--   x   |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--   s   |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--   o   |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--   t   |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--   l   |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

map({ "n" }, "<Esc>", "<CMD>nohlsearch<CR>", { desc = "Stop Highlight" })
map({ "n" }, "<leader>qq", "<CMD>qa<CR>", { desc = "Quit" })
-- 清除搜索高亮 + 更新 diff 差异 + <Ctrl-L> 重绘屏幕
map(
    { "n" },
    "<leader>ur",
    "<CMD>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / Clear hlsearch / Diff Update" }
)
map({ "n" }, "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map({ "n" }, "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- 查看原生 man printf，而不是 LSP 的悬停文档
map({ "n" }, "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
-- 快捷在上/下添加注释
map({ "n" }, "gco", "o<Esc>Vcx<Esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Below" })
map({ "n" }, "gcO", "O<Esc>Vcx<Esc><CMD>normal gcc<CR>fxa<BS>", { desc = "Add Comment Above" })
-- 新文件
map({ "n" }, "<leader>fn", "<CMD>enew<CR>", { desc = "New File" })
-- location list
map({ "n" }, "<leader>xl", function()
    local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
    end
end, { desc = "Location List" })
-- quickfix list
map({ "n" }, "<leader>xq", function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
    end
end, { desc = "Quickfix List" })

-- Insert 模式快捷键
map({ "i" }, "jk", "<Esc>", { desc = "Quit Insert Mode" })
map({ "i" }, "<C-l>", "<C-o>zz", { desc = "Line at center of window" })
map({ "i" }, "<C-j>", "<C-o>o", { desc = "Begin a new line below and insert" })
map({ "i" }, "<C-a>", "<C-o>^", { desc = "To the start of the line" })
map({ "i" }, "<C-e>", "<C-o>$", { desc = "To the end of the line" })

-- 自动保存
map({ "n", "i", "x", "s" }, "<C-s>", "<CMD>silent w<CR><Esc>", { desc = "Save File" })

-- wrap 启用时不会跳过续行（用 gj/gk 按显示行移动）
map({ "n", "x" }, "j", 'v:count == 0 ? "gj" : "j"', { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", 'v:count == 0 ? "gk" : "k"', { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", 'v:count == 0 ? "gj" : "j"', { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", 'v:count == 0 ? "gk" : "k"', { desc = "Up", expr = true, silent = true })

-- 快速跳转行首/行尾
map({ "n", "v", "o" }, "gh", "^", { desc = "To the start of the line" })
map({ "n", "v", "o" }, "gl", "$", { desc = "To the end of the line" })

-- 在窗口之间移动
map({ "n" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map({ "n" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map({ "n" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map({ "n" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- 分割窗口
map({ "n" }, "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map({ "n" }, "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })
map({ "n" }, "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- 连续缩进
map({ "v" }, "<", "<gv")
map({ "v" }, ">", ">gv")

-- 快速将当前行向上/下移动
map({ "n" }, "<A-j>", '<CMD>execute "move .+" . v:count1<CR>==', { desc = "Move Down" })
map({ "n" }, "<A-k>", '<CMD>execute "move .-" . (v:count1 + 1)<CR>==', { desc = "Move Up" })
map({ "i" }, "<A-j>", "<esc><CMD>m .+1<CR>==gi", { desc = "Move Down" })
map({ "i" }, "<A-k>", "<esc><CMD>m .-2<CR>==gi", { desc = "Move Up" })
map({ "v" }, "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move Down", silent = true })
map({ "v" }, "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move Up", silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- 在/或者?的搜索模式中, n始终向下, N始终向上
map({ "n" }, "n", '"Nn"[v:searchforward]."zv"', { expr = true, desc = "Next Search Result" })
map({ "n" }, "N", '"nN"[v:searchforward]."zv"', { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "n", '"Nn"[v:searchforward]', { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "N", '"nN"[v:searchforward]', { expr = true, desc = "Prev Search Result" })

-- 调整窗口大小
map({ "n" }, "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase Window Height" })
map({ "n" }, "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease Window Height" })
map({ "n" }, "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map({ "n" }, "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- tab 相关（<leader><Tab>*；注意 <tab> 与 <Tab> 是同一按键，勿重复注册）
map("n", "<leader><Tab>l", "<CMD>tablast<CR>", { desc = "Last Tab" })
map("n", "<leader><Tab>o", "<CMD>tabonly<CR>", { desc = "Close Other Tabs" })
map("n", "<leader><Tab>f", "<CMD>tabfirst<CR>", { desc = "First Tab" })
map("n", "<leader><Tab><Tab>", "<CMD>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader><Tab>]", "<CMD>tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader><Tab>d", "<CMD>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader><Tab>[", "<CMD>tabprevious<CR>", { desc = "Previous Tab" })

-- LSP / Diagnostic
local diagnostic_goto = function(next, severity)
    return function()
        vim.diagnostic.jump({
            count = (next and 1 or -1) * vim.v.count1,
            severity = severity and vim.diagnostic.severity[severity] or nil,
            -- nvim 0.12: float 参数已废弃 (0.14 移除), 用 on_jump 等价实现 (跳转后显示浮窗, 不抢焦点)
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
            end,
        })
    end
end
map({ "n" }, "<leader>cd", function()
    local float_bufnr = vim.diagnostic.open_float()
    if float_bufnr then
        local wins = vim.fn.win_findbuf(float_bufnr)
        if wins[1] then
            vim.api.nvim_set_current_win(wins[1])
        end
    end
end, { desc = "Line Diagnostics" })
map({ "n" }, "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map({ "n" }, "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map({ "n" }, "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map({ "n" }, "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map({ "n" }, "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map({ "n" }, "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- UI / 结构检查（vim.show_pos 查看光标处高亮组，treesitter 检查语法树）
map({ "n" }, "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map({ "n" }, "<leader>uI", function()
    vim.treesitter.inspect_tree()
    vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })
