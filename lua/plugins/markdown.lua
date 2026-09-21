-- markdown: 渲染增强
return {
    -- render-markdown: markdown 预览
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "md",
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
            checkbox = {
                enabled = false,
            }
        }
    }
}
