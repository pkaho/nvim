return {
    -- gitsigns: Git 改动符号、hunk 跳转/暂存/重置/blame
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc, silent = true })
                end

                -- stylua: ignore start
                local function make_h_move(cmd, pn)
                    return function()
                        if vim.wo.diff then
                            vim.cmd.normal({ cmd, bang = true })
                        else
                            gs.nav_hunk(pn)
                        end
                    end
                end
                map({ "n" }, "]h", make_h_move("]c", "next"), "Next Hunk")
                map({ "n" }, "[h", make_h_move("[c", "prev"), "Prev Hunk")
                map({ "n" }, "]H", function() gs.nav_hunk("last") end, "Last Hunk")
                map({ "n" }, "[H", function() gs.nav_hunk("first") end, "First Hunk")

                map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

                map({ "n" }, "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map({ "n" }, "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map({ "n" }, "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map({ "n" }, "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")

                map({ "n" }, "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map({ "n" }, "<leader>ghB", function() gs.blame() end, "Blame Buffer")

                map({ "n" }, "<leader>ghd", gs.diffthis, "Diff This")

                map({ "n" }, "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")

                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

                -- 项目根检测见 lua/config/root.lua（LazyVim util/root 的精简版）
                local root_git = require("config.root").git
                map({ "n" },"<leader>gg", function() Snacks.lazygit({ cwd = root_git() }) end,"Lazygit (Root Dir)" )
                map({ "n" },"<leader>gG", function() Snacks.lazygit() end,"Lazygit (cwd)" )
                map({ "n" },"<leader>gb", function() Snacks.picker.git_log_line() end,"Git Blame Line" )
                map({ "n" },"<leader>gl", function() Snacks.picker.git_log_line({ cwd = root_git() }) end,"Git Log" )
                map({ "n" },"<leader>gL", function() Snacks.picker.git_log() end,"Git Log (cwd)" )
                map({ "n" },"<leader>gf", function() Snacks.picker.git_log_file() end,"Git Log File" )
                map({ "n" },"<leader>gs", function() Snacks.picker.git_status() end,"Git Status")
                map({ "n" },"<leader>gS", function() Snacks.picker.git_stash() end,"Git Stash" )
                map({ "n" },"<leader>gd", function() Snacks.picker.git_diff() end,"Git Diff (Hunks)" )
                map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, "Git Browse (open)")
                map({ "n", "x" }, "<leader>gY", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end, "Git Browse (copy)")
                -- gh
                map({ "n" }, "<leader>gi", function() Snacks.picker.gh_issue() end,                  "GitHub Issues (open)" )
                map({ "n" }, "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, "GitHub Issues (all)")
                map({ "n" }, "<leader>gp", function() Snacks.picker.gh_pr() end,                     "GitHub Pull Requests (open)" )
                map({ "n" }, "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,    "GitHub Pull Requests (all)" )
            end,
        },
    },
    -- 同一插件的第二个 spec: lazy.nvim 会将两条 spec 合并 (opts 函数追加)
    -- 在此新增 <leader>uG 切换 Git 行号符号显示
    {
        "lewis6991/gitsigns.nvim",
        opts = function()
            Snacks.toggle({
                name = "Git Signs",
                get = function()
                    return require("gitsigns.config").config.signcolumn
                end,
                set = function(state)
                    require("gitsigns").toggle_signs(state)
                end,
            }):map("<leader>uG")
        end,
    },
}
