return {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },
    keys = {
        {
            "<leader>g",
            group = "Git (neogit)",
            {
                "<leader>gg",
                function()
                    require('neogit').open({ kind = "auto" })
                end,
            },
        },

    }
}
