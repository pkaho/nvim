return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = {"spec"},
    opts = {
      preset = "helix", -- classic, modern, helix
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      }
    }
  },

  -- :line num，查看行号内容
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {
      show_numbers = true,
      show_cursorline = true,
    }
  },

  -- 颜色可视化和选择器
  {
    "norcalli/nvim-colorizer.lua",
    opts = { "*" },
  },
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>cp", "<CMD>CccPick<CR>", desc = "ColorPick" },
    }
  },
}
