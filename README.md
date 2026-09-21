# Neovim 配置

基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 的个人配置。

## 目录结构

```
init.lua            入口：依次加载 config/ 下的基础层
lua/config/         基础层：options（选项）/ keybinds（按键）/ autocmds（自动命令）/ lazy（lazy.nvim 引导）
lua/plugins/        插件层：按功能域一个文件一个主题，命名规范见下
```

- **命名规范**：`lua/config/` 按职责命名；`lua/plugins/` 按功能域命名，单一插件用核心名，多插件聚合文件内插件必须强相关且不超过 4 个。
- **拆分关系**：`folke.lua` → noice / flash / trouble / persistence / todo-comments；`coding.lua` → editing / search / color / markdown。

## 外部系统工具

- ripgrep
- fd
- tree-sitter
- nodejs(npm)
- lazygit
- hledger

## 需 Mason 安装的工具

- LSP：`lua_ls`、`pyright`（`lsp.lua` 中 `ensure_installed` 已自动安装）
- 格式化（`formatter.lua`）：`stylua`、`ruff`、`prettier`、`yamlfmt`、`shfmt`
- lint（`hledger.lua`）：`ruff`、`hledger`、`fish`

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
