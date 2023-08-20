return {
    "xeluxee/competitest.nvim",
	dependencies = 'MunifTanjim/nui.nvim',
	config = function() require('competitest').setup{
        compile_command = {
            c = { exec = "clang", args = { "-Wall -Wextra -g3", "$(FNAME)", "-o", "$(FNOEXT)" } },
            cpp = { exec = "clang++", args = { "-Wall -Wextra -g3", "$(FNAME)", "-o", "$(FNOEXT)" } },
            rust = { exec = "rustc", args = { "$(FNAME)" } },
            java = { exec = "javac", args = { "$(FNAME)" } },
        },
        evaluate_template_modifiers = true,
        template_file = "~/dev/cp/template.cc"
    } end,
    keys = {
      { "<leader>cr", "<cmd>CompetiTest run<cr>", desc = "Competitive programming run" },
      { "<leader>cp", "<cmd>CompetiTest receive problem<cr>", desc = "Competitive programming receive" },
      { "<leader>ci", "<cmd>CompetiTest show_ui<cr>", desc = "Competitive programming UI" },
    }
}

