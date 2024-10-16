return {
{
    "numToStr/Comment.nvim",
    event = "BufEnter",
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = function()
                require("ts_context_commentstring").setup({
                    enable_autocmd = false,
                })
            end,
        },
    },
    config = function()
        require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })

        local ft = require("Comment.ft")
        ft.set("reason", { "//%s", "/*%s*/" })
    end,
}
}

