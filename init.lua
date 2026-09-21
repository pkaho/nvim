-- 配置入口：按职责拆分到 lua/config/ 下，各自独立维护
require("config.options")  -- 编辑器全局选项（lua/config/options.lua）
require("config.keybinds") -- 全局按键映射（lua/config/keybinds.lua）
require("config.autocmds") -- 全局自动命令（lua/config/autocmds.lua）
require("config.lazy")     -- 插件管理 lazy.nvim，自动导入 lua/plugins/ 下的插件配置
