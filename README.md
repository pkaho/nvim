# Neovim 配置

基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 的个人配置（Windows 环境）。

## 目录结构

```
init.lua              入口：依次加载 lua/config/ 基础层
lua/config/           基础层：options（选项）/ keybinds（按键）/ autocmds（自动命令）
                      / root（项目根检测，LazyVim util/root 精简版）/ lazy（lazy.nvim 引导）
lua/plugins/          插件层：按功能域组织（目录 = 功能域）
  init.lua            功能域注册表：新增功能域在此登记一行
  ui/                 界面：状态栏 / 标签栏 / 通知 / dashboard / picker / 主题
  lsp/                语言服务：mason / 补全 / LSP 客户端，按语言继续拆分
  editing/            编辑增强：配对 / 多光标 / 文本对象 / 递增
  search/             搜索导航：跨文件替换 / 快速跳转 / TODO
  git/                git 集成：gitsigns / lazygit
  lang/               语言与格式：treesitter / 格式化 / lint / 专用语言
  tools/              工具杂项：任务运行器 / 会话
stylua.toml           配置代码格式规范（stylua，统一缩进/列宽/换行）
lazy-lock.json        插件版本锁：提交到 git，换机器/回滚时可复现
```

### 约定

- **目录 = 功能域**：新插件按功能归属放进对应域的 `.lua`（或新建文件），域内文件无需写 init.lua。
- **键位归属**：插件专属键位写在插件配置的 `keys=` 字段；全局键位集中在 `lua/config/keybinds.lua` 并按区块分节。
- **格式规范**：lua 代码用 stylua 统一格式化（`stylua.toml`，4 空格缩进、120 列宽、LF 换行）；保存时 conform 自动格式化。
- **注释语言**：中文注释，写"为什么"而非"是什么"。
- **项目根检测**：`<leader>gg` / `<leader>gl` 以 git 仓库根目录为 cwd，检测逻辑在 `lua/config/root.lua`（精简自 LazyVim）。

## 如何加一个插件

1. 判断功能归属，把插件 spec 写进对应域的 `.lua`（多插件强相关可共文件，否则一插件一文件）。
2. 文件内规范：一行插件名注释 + spec；懒加载用 `event` / `cmd` / `keys`；每个键位写 `desc`。
3. 保存后 lazy.nvim 会自动安装缺失插件（默认启动时检测）。
4. 验证：`:Lazy` 查看状态；`:checkhealth <插件名>` 检查依赖。

## 如何更新

- `:Lazy update` 更新全部插件；`:Lazy update <插件名>` 更新单个。
- 更新后 `lazy-lock.json` 会变化，记得一并提交（版本可复现的关键）。
- 更新后出问题：`git log --oneline` 看最近变更，`git diff lazy-lock.json` 可回退插件版本。

## 如何排查

1. `:messages` 查看最近报错；`:checkhealth` 整体健康检查；`:Lazy health` 插件健康。
2. 无头加载冒烟测试（无输出即正常）：`nvim --headless +qa`
3. 改完配置代码统一格式化：`stylua lua/`（stylua.toml 在仓库根）。

## 外部系统工具

- ripgrep
- fd
- tree-sitter
- nodejs(npm)
- lazygit
- hledger

## 需 Mason 安装的工具

- LSP：`lua_ls`、`pyright`（`lsp/core.lua` 中 `ensure_installed` 已自动安装）
- 格式化（`lang/formatter.lua`）：`stylua`、`ruff`、`prettier`、`yamlfmt`、`shfmt`
- lint（`lang/nvim-lint.lua`）：`ruff`、`hledger`、`fish`

## 常用快捷键速查

| 前缀 | 含义 |
| --- | --- |
| `<leader>c` | code：格式化 / 重命名 / 代码操作 / LSP |
| `<leader>g` | git：hunk / blame / browse |
| `<leader>s` | search：picker / grep / todo |
| `<leader>b` | buffer 管理 |
| `<leader>x` | diagnostics / quickfix |
| `<leader>u` | ui：主题 / 颜色 / inspect |
| `<leader>q` | quit / session |
| `<leader>w` | windows |
