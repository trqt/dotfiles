return {
    { "nvim-lua/plenary.nvim", lazy = true },

    { "nvim-telescope/telescope.nvim", cmd = "Telescope", version = false,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },
            { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git Files (root dir)" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Grep Files (root dir)" }
        }
    },
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
    { 'rose-pine/neovim', name = 'rose-pine' }
}
