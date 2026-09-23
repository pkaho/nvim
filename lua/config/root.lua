-- 项目根检测（LazyVim lua/lazyvim/util/root.lua 的精简版）
-- 检测顺序：LSP workspace/root_dir → 项目标记文件（.git / lua）→ 当前工作目录
-- 用途：<leader>gg / <leader>gl 以 git 仓库根目录为 cwd 运行 lazygit / git log
local M = {}

--- 项目标记文件：向上找到任一即视为项目根
local patterns = { ".git", "lua" }

--- 统一为正斜杠路径（nvim 内部 / vim.fs 使用正斜杠，cwd/buffer 名可能混用反斜杠）
local function norm(p)
    return (p or ""):gsub("\\", "/")
end

--- 当前 buffer 的路径（无 buffer 时回退 cwd）
local function bufpath()
    local path = vim.api.nvim_buf_get_name(0)
    return path ~= "" and path or vim.uv.cwd()
end

--- 取 LSP 客户端报告的 workspace 根目录
local function lsp_roots()
    local ret = {}
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        for _, ws in pairs(client.config.workspace_folders or {}) do
            ret[#ret + 1] = vim.uri_to_fname(ws.uri)
        end
        if client.root_dir then
            ret[#ret + 1] = client.root_dir
        end
    end
    return ret
end

--- 项目根：LSP 根（须包含当前 buffer）优先，其次向上找标记文件，最后回退 cwd
function M.get()
    local path = norm(bufpath())
    for _, root in ipairs(lsp_roots()) do
        root = norm(root)
        if path:find(root, 1, true) == 1 then
            return root
        end
    end
    local found = vim.fs.find(patterns, { path = path, upward = true })[1]
    return found and norm(vim.fs.dirname(found)) or norm(vim.uv.cwd())
end

--- git 仓库根：在项目根基础上向上找 .git；找不到时回退项目根
function M.git()
    local root = M.get()
    local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
    return git_root and norm(vim.fn.fnamemodify(git_root, ":h")) or root
end

return M
