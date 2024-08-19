return {
    { "nvim-lua/plenary.nvim", lazy = true },

    { "mbbill/undotree", cmd = "UndotreeToggle",
        keys = {
	        { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree"}
        }
    },
    { "tpope/vim-fugitive", cmd = "Git",
        keys = {
	        { "<leader>gs", "<cmd>Git<cr>", desc = "Fugitive Git" }
	    }
    },
    { "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    { "github/copilot.vim", cmd = "Copilot" },
    --[[{ "m4xshen/hardtime.nvim",
       dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
       opts = {}
    },]]--
    { "lervag/vimtex", lazy = false,
        init = function()
            vim.g.vimtex_view_method = "sioyek"
        end
    },
    { "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require('todo-comments').setup() end,
    },
    { "savq/melange-nvim" },
    { "rebelot/kanagawa.nvim" }
}
