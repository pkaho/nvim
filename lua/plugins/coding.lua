return {
    {
        "altermo/ultimate-autopair.nvim",
        event = {"InsertEnter", "CmdlineEnter"},
        branch = "v0.6",
        opts={}
    },

    {
        "echasnovski/mini.ai",
        version = false,
        opts = {}
    },

    {
        "echasnovski/mini.surround",
        version = false,
        opts = {
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",

                suffix_last = "l",
                suffix_next = "n"
            }
        }
    },

    {
        "echasnovski/mini.align",
        version = false,
        opts = {}
    },
}
