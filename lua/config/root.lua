---@class lazyvim.util.root
---@overload fun(): string
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.get(...)
    end,
})

---@class LazyRoot
---@field paths string[]
---@field spec LazyRootSpec

---@alias LazyRootFn fun(buf: number): (string|string[])

---@alias LazyRootSpec string|string[]|LazyRootFn

-- 根目录判定优先级（自上而下，先命中者胜）：
--   1. "lsp"           当前 buffer 的 LSP workspace/root_dir
--   2. { ".git", "lua" } 向上查找的根标记文件/目录
--   3. "cwd"           兜底用当前工作目录
---@type LazyRootSpec[]
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

M.detectors = {}

-- 检测器：当前工作目录
function M.detectors.cwd()
    return { vim.uv.cwd() }
end

-- 检测器：LSP 工作区。收集客户端声明的 workspace_folders 与 root_dir，
-- 仅保留位于当前 buffer 路径前缀内的项（避免串用其他项目的根）
function M.detectors.lsp(buf)
    local bufpath = M.bufpath(buf)
    if not bufpath then
        return {}
    end
    local roots = {} ---@type string[]
    local clients = vim.lsp.get_clients({ bufnr = buf })
    clients = vim.tbl_filter(function(client)
        return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name)
    end, clients) --[[@as vim.lsp.Client[] ]]
    for _, client in pairs(clients) do
        local workspace = client.config.workspace_folders
        for _, ws in pairs(workspace or {}) do
            roots[#roots + 1] = vim.uri_to_fname(ws.uri)
        end
        if client.root_dir then
            roots[#roots + 1] = client.root_dir
        end
    end
    return vim.tbl_filter(function(path)
        path = vim.fs.normalize(path)
        return path and bufpath:find(path, 1, true) == 1
    end, roots)
end

-- 检测器：根标记模式。从当前 buffer 所在目录逐级向上查找 patterns 中的标记
-- （支持 "name" 精确匹配与 "*name" 后缀匹配），返回命中目录
---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
    patterns = type(patterns) == "string" and { patterns } or patterns
    local path = M.bufpath(buf) or vim.uv.cwd()
    local pattern = vim.fs.find(function(name)
        for _, p in ipairs(patterns) do
            if name == p then
                return true
            end
            if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
                return true
            end
        end
        return false
    end, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
end

-- 当前 buffer 的真实路径（不存在时返回 nil）
function M.bufpath(buf)
    return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

-- 当前工作目录的真实路径
function M.cwd()
    return M.realpath(vim.uv.cwd()) or ""
end

-- 规范化路径：Windows 下不做 fs_realpath（大小写/软链语义与 Unix 不同），仅统一分隔符
function M.realpath(path)
    if path == "" or path == nil then
        return nil
    end
    path = vim.fn.has("win32") == 0 and vim.uv.fs_realpath(path) or path
    return vim.fs.normalize(path)
end

-- 将 spec 条目解析为可调用的检测函数：
--   字符串 → 查 detectors 表（内置检测器）；函数 → 原样返回；其他 → 当作根标记模式
---@param spec LazyRootSpec
---@return LazyRootFn
function M.resolve(spec)
    if M.detectors[spec] then
        return M.detectors[spec]
    elseif type(spec) == "function" then
        return spec
    end
    return function(buf)
        return M.detectors.pattern(buf, spec)
    end
end

-- 按 spec 列表依次检测根目录，返回命中的根（可含多路径，按路径长度降序）
-- opts.all = false 时只保留第一个命中的检测器结果
---@param opts? { buf?: number, spec?: LazyRootSpec[], all?: boolean }
function M.detect(opts)
    opts = opts or {}
    opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
    opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

    local ret = {} ---@type LazyRoot[]
    for _, spec in ipairs(opts.spec) do
        local paths = M.resolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == "table" and paths or { paths }
        local roots = {} ---@type string[]
        for _, p in ipairs(paths) do
            local pp = M.realpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
                roots[#roots + 1] = pp
            end
        end
        table.sort(roots, function(a, b)
            return #a > #b
        end)
        if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
                break
            end
        end
    end
    return ret
end

-- 展示当前 buffer 的根目录检测结果（供 :LazyRoot 命令使用）
function M.info()
    local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec

    local roots = M.detect({ all = true })
    local lines = {} ---@type string[]
    local first = true
    for _, root in ipairs(roots) do
        for _, path in ipairs(root.paths) do
            lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
                first and "x" or " ",
                path,
                type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
            )
            first = false
        end
    end
    lines[#lines + 1] = "```lua"
    lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
    lines[#lines + 1] = "```"
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "LazyVim Roots" })
    return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

-- 按 buffer 缓存检测结果，避免重复扫描
---@type table<number, string>
M.cache = {}

-- 注册 :LazyRoot 命令与缓存失效事件
function M.setup()
    vim.api.nvim_create_user_command("LazyRoot", function()
        M.info()
    end, { desc = "LazyVim roots for the current buffer" })

    -- FIX: neo-tree 的 set_root 未能正确清理缓存（按理应在 DirChanged 时触发），
    -- 可能是因为该事件是在 neo-tree buffer 里触发的，因此额外监听 BufEnter
    -- BufEnter 触发可能过于频繁，后续如有性能问题需另想方案
    vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("lazyvim_root_cache", { clear = true }),
        callback = function(event)
            M.cache[event.buf] = nil
        end,
    })
end

-- 获取当前（或指定）buffer 的根目录，判定来源依次为：
--   * LSP workspace folders
--   * LSP root_dir
--   * 当前 buffer 文件名向上的根标记
--   * 当前工作目录
-- 结果按 buffer 缓存；默认返回平台风格路径（Windows 为反斜杠），normalize = true 时返回正斜杠路径
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.get(opts)
    opts = opts or {}
    local buf = opts.buf or vim.api.nvim_get_current_buf()
    local ret = M.cache[buf]
    if not ret then
        local roots = M.detect({ all = false, buf = buf })
        ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
        M.cache[buf] = ret
    end
    if opts and opts.normalize then
        return ret
    end
    return vim.fn.has("win32") == 1 and ret:gsub("/", "\\") or ret
end

-- Git 根目录：从项目根向上找 .git 目录，返回其父目录；找不到则退回项目根
function M.git()
    local root = M.get()
    local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
    local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
    return ret
end

-- 保留占位：LazyVim 原版用于状态栏展示美化路径，本精简版不启用
---@param opts? {hl_last?: string}
function M.pretty_path(opts)
    return ""
end

return M
