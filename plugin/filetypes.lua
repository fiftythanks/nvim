-- Tree-sitter filetype-to-parser mappings.
-- Sourced by Neovim on startup and by Neotest child processes via `runtime! plugin/filetypes.lua`.

local filetypes = {
  tsx = { 'typescriptreact', 'typescript.tsx' },
  javascript = { 'javascriptreact', 'ecma', 'ecmascript', 'jsx', 'js' },
  typescript = { 'ts' },
}

for lang, ft in pairs(filetypes) do
  vim.treesitter.language.register(lang, ft)
end
