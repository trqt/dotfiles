local lsp = require('lsp-zero').preset({
    setup_servers_on_start = false,
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup_servers({'clangd', 'rust_analyzer', 'gopls', 'lua_ls', 'pylsp', 'ruff', 'ocamllsp', 'hls', 'texlab'})

lsp.setup()
