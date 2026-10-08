# Agent Guidelines for Neovim Configuration

This document defines core instructions, Conventional Commits standards, and modern (2026) Lua/Neovim best practices for AI agents working in this repository.

---

## 1. Conventional Commits Standards (Strict Enforcement)

All commits in this repository must strictly follow the **[Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)** specification.

### Commit Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Allowed Types
- **`feat`**: Introduces a new feature, plugin, or language server capability.
- **`fix`**: Fixes a bug, crash, or broken configuration.
- **`docs`**: Documentation changes (e.g. `README.md`, `GEMINI.md`, inline docs).
- **`style`**: Formatting, whitespace, or cosmetic code adjustments.
- **`refactor`**: Code restructuring that neither fixes a bug nor adds a feature.
- **`perf`**: Optimizations that improve startup time or runtime responsiveness.
- **`test`**: Adding, updating, or fixing tests.
- **`build`**: Changes affecting external tools, Mason packages, or dependencies.
- **`ci`**: CI/CD configuration files and scripts.
- **`chore`**: Maintenance, `.gitignore` updates, or general repo hygiene.
- **`revert`**: Reverts a previous commit.

### Scopes (Per-Configuration File)
Each configuration file or module in this repository has its own designated scope:

| Scope | Target File / Area |
| :--- | :--- |
| **`init`** | `init.lua` |
| **`options`** | `lua/config/options.lua` |
| **`keymaps`** | `lua/config/keymaps.lua` |
| **`autocmds`** | `lua/config/autocmds.lua` |
| **`lazy`** | `lua/config/lazy.lua` |
| **`local`** | `lua/config/local.lua.example` / local machine overrides |
| **`lsp`** | `lua/plugins/lsp.lua` |
| **`ui`** | `lua/plugins/ui.lua` |
| **`ai`** | `lua/plugins/ai.lua` |
| **`coding`** | `lua/plugins/coding.lua` |
| **`completion`** | `lua/plugins/completion.lua` |
| **`dap`** | `lua/plugins/dap.lua` |
| **`editor`** | `lua/plugins/editor.lua` |
| **`formatting`** | `lua/plugins/formatting.lua` |
| **`git`** | `lua/plugins/git.lua` |
| **`lang`** | `lua/plugins/lang.lua` |
| **`notes`** | `lua/plugins/notes.lua` |
| **`telescope`** | `lua/plugins/telescope.lua` |
| **`testing`** | `lua/plugins/testing.lua` |
| **`treesitter`** | `lua/plugins/treesitter.lua` / custom queries |
| **`filetypes`** | `plugin/filetypes.lua` |
| **`readme`** | `README.md` |
| **`gemini`** | `GEMINI.md` |

*Note: If a change spans multiple components or repository-wide scaffolding, select the primary file's scope or omit the scope if truly global.*

### Formatting Rules & Checklist
1. **Header Line**:
   - Pattern: `<type>(<scope>): <description>` (e.g. `feat(lsp): configure somesass_ls and scope CSS servers`).
   - `type` and `scope` must be lowercase.
   - Use the **imperative mood** for `<description>` ("add", "fix", "scope", not "added" or "fixes").
   - Start `<description>` with a lowercase letter.
   - Do **not** end `<description>` with a period.
   - Hard upper limit: **72 characters** (recommended: 50 characters or less).
2. **Blank Line**: Exactly one empty line between the header and body.
3. **Body**:
   - Manually hard-wrapped so that no line exceeds **72 characters**.
   - Explains **what** changed and **why**, rather than trivial syntax diffs.
4. **Breaking Changes**:
   - Append `!` before the colon (e.g., `feat(lsp)!: ...`) or include `BREAKING CHANGE: <description>` in the footer.

---

## 2. Modern Lua & Neovim Best Practices (2026)

Target environment: **Neovim >= 0.12** running on **LuaJIT 2.1**.

### A. Native LSP Configuration (Neovim 0.11+)
- **Use `vim.lsp.config` and `vim.lsp.enable`**:
  Neovim natively decouples server specification from server activation.
  - Do **not** use the deprecated `require('lspconfig').<server>.setup({...})` framework.
  - Define server settings, `root_markers`, and hooks via `vim.lsp.config('<server_name>', {...})`.
  - Enable servers via `vim.lsp.enable({ '<server_name>', ... })`.
- **Root detection**:
  - Prefer `root_markers = { '.git', 'package.json' }` over legacy pattern matchers.
- **Dynamic initialization**:
  - Use the `before_init(initialize_params, config)` hook when workspace configurations, alias mappings, or load paths need dynamic calculation at runtime based on `config.root_dir`.
- **Server scoping**:
  - Avoid duplicate hover popups or overlapping completions by scoping language servers to their specific filetypes (e.g., scoping CSS servers to `css` and `less` when a specialized server like `somesass_ls` handles `scss`).

### B. Standard Library & Neovim APIs
- **Functional collection processing (`vim.iter`)**:
  - Use `vim.iter` for transforming, filtering, mapping, or querying tables and lists instead of imperative `for _, v in ipairs(...)` boilerplate:
    ```lua
    local active_names = vim.iter(vim.lsp.get_clients())
      :map(function(client) return client.name end)
      :totable()
    ```
- **Filesystem & path manipulation (`vim.fs`)**:
  - Use `vim.fs.joinpath(...)` instead of manual string concatenation with `'/'`.
  - Use `vim.fs.root(...)` and `vim.fs.dirname(...)` instead of `vim.fn.fnamemodify`.
- **Event loop / libuv (`vim.uv`)**:
  - Always use `vim.uv` (e.g. `vim.uv.fs_stat`, `vim.uv.fs_scandir`). Never use the deprecated `vim.loop`.
- **API calls over Vimscript**:
  - Prefer native Lua APIs (`vim.api.*`) over `vim.fn.*` where equivalents exist to avoid serialization overhead between Lua and the Vimscript engine.
- **Keymaps & Autocommands**:
  - Always map keys using `vim.keymap.set(mode, lhs, rhs, opts)` and include a descriptive `desc = "..."` field.
  - Always assign autocommands to clearable augroups:
    ```lua
    local group = vim.api.nvim_create_augroup('MyGroup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'markdown',
      callback = function() ... end,
    })
    ```

### C. LuaJIT Performance Guidelines
- **Always localize scope**:
  - Every variable and function must be explicitly scoped with `local`. Never leak variables into global `_G`.
- **Avoid global lookups in hot loops**:
  - Cache standard library functions locally if called repeatedly in high-frequency loops or callbacks (e.g., `local sin = math.sin`).
- **Efficient string construction**:
  - Strings in Lua are immutable. Never concatenate strings using `..` inside loops. Instead, accumulate elements into a table and call `table.concat(parts)`.
- **Array table consistency**:
  - Keep list-like tables contiguous (avoid `nil` holes) so LuaJIT optimizes them as contiguous C arrays rather than falling back to hash maps.

### D. Plugin Management & Lazy Loading (`lazy.nvim`)
- **Category-based organization**:
  - Specifications live under `lua/plugins/<category>.lua`.
  - New standalone plugins should either be added to their relevant category or placed in a dedicated file auto-imported by `lazy.nvim`.
- **Lazy loading**:
  - Defer non-critical plugins using `event = 'VeryLazy'`, `ft = { ... }`, `cmd = { ... }`, or `keys = { ... }`.
  - Prefer `opts = {}` over explicit `config = function(_, opts) require('...').setup(opts) end` when default initialization suffices.

---

## 3. Privacy & Secrets Management

- **Zero secrets in Git**:
  - API tokens, Google Cloud Project IDs, private keys, and machine-specific file paths must **never** be committed.
- **Local overrides pattern**:
  - Load machine-specific configuration from `lua/config/local.lua` (git-ignored) or environment variables (e.g., `vim.env.VERTEX_PROJECT_ID`).
  - Provide safe fallback defaults so the configuration starts cleanly without throwing errors if local overrides are absent.
