# Neovim Configuration

<div align="center">

![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![lazy.nvim](https://img.shields.io/badge/Plugin_Manager-lazy.nvim-blueviolet?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1%20%2F%20LuaJIT-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Theme](https://img.shields.io/badge/Theme-VS%20Code%20Dark-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)

A clean, modular, and high-performance Neovim setup powered by **[lazy.nvim](https://github.com/folke/lazy.nvim)** with full LSP, Treesitter, DAP debugging, testing, and AI assistant integration.

[Architecture](#-architecture) •
[Plugin Breakdown](#-plugin-breakdown) •
[Keybindings](#-keybindings-cheat-sheet) •
[Customization](#-how-to-customize--extend) •
[Prerequisites](#-prerequisites)

</div>

---

## Architecture

The configuration separates **core editor options**, **general keymaps**, and **autocommands** into `lua/config/`, while all plugin specifications live modularly under `lua/plugins/`.

```
~/.config/nvim/
├── init.lua                   # Entry point (sets leader, loads local overrides, config & lazy)
├── README.md                  # Documentation and architecture guide
├── .gitignore                 # Ignores compiled parsers, local secrets, and swap files
├── lazy-lock.json             # Pinned plugin commit hashes
├── plugin/
│   └── filetypes.lua          # Treesitter filetype-to-parser registrations
├── queries/                   # Custom Treesitter query injections & highlights
│   ├── norg/highlights.scm    # Custom Neorg link highlights
│   └── python/injections.scm  # Render Python comments as Markdown
└── lua/
    ├── config/
    │   ├── options.lua        # Editor options, filetypes, and diagnostic settings
    │   ├── keymaps.lua        # Core keymaps (navigation, readline motions, windows)
    │   ├── autocmds.lua       # Autocommands and custom user commands
    │   ├── lazy.lua           # lazy.nvim bootstrapper & automatic plugin importer
    │   ├── local.lua.example  # Template for machine-specific overrides & secrets
    │   └── local.lua          # (Optional) Local machine overrides & secrets (Git-ignored)
    │
    └── plugins/               # Modular plugin specifications (auto-imported)
        ├── ai.lua             # CodeCompanion (Vertex AI), Copilot, img-clip
        ├── coding.lua         # Autopairs, surround, comments, refactoring, illuminate
        ├── completion.lua     # Blink.cmp completion engine & providers
        ├── dap.lua            # DAP debugger, CodeLLDB adapter, dap-python, overseer
        ├── editor.lua         # Nvim-tree, Trouble, Todo-comments, Nerdy, Zoxide
        ├── formatting.lua     # Conform.nvim (format-on-save) & nvim-lint
        ├── git.lua            # Gitsigns (hunk ops, blame) & Neogit
        ├── lang.lua           # Rustaceanvim (rust-analyzer) & venv-selector
        ├── lsp.lua            # Native LSP config, Mason, Lspsaga, inc-rename
        ├── notes.lua          # Neorg, Obsidian, Markview, Store
        ├── telescope.lua      # Telescope fuzzy finder & extensions
        ├── testing.lua        # Neotest (Jest, Playwright, Python)
        ├── treesitter.lua     # Syntax highlighting, queries, & textobjects
        └── ui.lua             # VS Code / Catppuccin themes, Lualine, Devicons, ccc
```

---

## Plugin Breakdown

| Module | Category | Featured Plugins & Highlights |
| :--- | :--- | :--- |
| [`ui.lua`](lua/plugins/ui.lua) | **Appearance & Themes** | `visual_studio_code`, `catppuccin`, `lualine.nvim`, `nvim-web-devicons`, `deadcolumn.nvim`, `ccc.nvim` (color picker) |
| [`lsp.lua`](lua/plugins/lsp.lua) | **Language Server Protocol** | `nvim-lspconfig` (native `vim.lsp`), `mason.nvim`, `lspsaga.nvim`, `lazydev.nvim`, `inc-rename.nvim`, `typescript-tools.nvim`, `somesass_ls` (SassDoc & SCSS) |
| [`completion.lua`](lua/plugins/completion.lua) | **Autocompletion** | `blink.cmp` (Rust fuzzy matching), `friendly-snippets`, `blink-ripgrep`, `csc.nvim`, `colorful-menu.nvim` |
| [`treesitter.lua`](lua/plugins/treesitter.lua) | **Syntax & Motions** | `nvim-treesitter` (20+ parsers), `nvim-treesitter-textobjects` (syntax-aware motions & repeatable moves) |
| [`telescope.lua`](lua/plugins/telescope.lua) | **Fuzzy Finder** | `telescope.nvim`, `telescope-fzf-native`, `media-files`, `repo`, `all-recent`, `zoxide` |
| [`editor.lua`](lua/plugins/editor.lua) | **Workspace & Navigation** | `nvim-tree.lua`, `trouble.nvim`, `todo-comments.nvim`, `nerdy.nvim` (icon picker), `range-highlight`, `rooter.nvim` |
| [`coding.lua`](lua/plugins/coding.lua) | **Editing Utilities** | `nvim-autopairs`, `nvim-surround`, `Comment.nvim`, `refactoring.nvim`, `vim-illuminate` |
| [`formatting.lua`](lua/plugins/formatting.lua) | **Lint & Format** | `conform.nvim` (Prettier, Stylua, Ruff, Shfmt, Taplo) & `nvim-lint` (Actionlint, Shellcheck, etc.) |
| [`git.lua`](lua/plugins/git.lua) | **Version Control** | `gitsigns.nvim` (inline diffs, stage hunks, blame), `neogit` (interactive git client) |
| [`dap.lua`](lua/plugins/dap.lua) | **Debugging & Tasks** | `nvim-dap` (CodeLLDB / Tauri / Rust), `nvim-dap-ui`, `nvim-dap-python`, `overseer.nvim` (task runner) |
| [`testing.lua`](lua/plugins/testing.lua) | **Test Runner** | `neotest` with adapters for `neotest-jest`, `neotest-playwright`, and `neotest-python` |
| [`notes.lua`](lua/plugins/notes.lua) | **Note Taking & Docs** | `neorg` (workspaces, journal, todo items), `obsidian.nvim`, `markview.nvim` |
| [`ai.lua`](lua/plugins/ai.lua) | **AI Pair Programming** | `codecompanion.nvim` (Vertex AI / Gemini adapter), `copilot.lua`, `img-clip.nvim` |
| [`lang.lua`](lua/plugins/lang.lua) | **Language Specific** | `rustaceanvim` (custom rust-analyzer settings), `venv-selector.nvim` |

---

## Keybindings Cheat Sheet

Leader key is mapped to <kbd>Space</kbd>.

### Navigation & General

| Keybinding | Mode | Action |
| :--- | :---: | :--- |
| <kbd>Alt</kbd> + <kbd>h</kbd> / <kbd>j</kbd> / <kbd>k</kbd> / <kbd>l</kbd> | `n`, `i`, `t` | Navigate between window splits |
| <kbd>Ctrl</kbd> + <kbd>w</kbd> <kbd>n</kbd> | `n` | Create vertical split buffer (`:vnew`) |
| <kbd>Space</kbd> <kbd>Ctrl</kbd> + <kbd>q</kbd> | `n` | Close current tab page (`:tabclose`) |
| <kbd>Esc</kbd> | `t` | Exit terminal mode to normal mode |
| <kbd>Ctrl</kbd> + <kbd>a</kbd> / <kbd>e</kbd> | `i`, `c` | Move to start / end of line (Readline style) |
| <kbd>Ctrl</kbd> + <kbd>b</kbd> / <kbd>f</kbd> | `i`, `c` | Move left / right (Readline style) |
| <kbd>Space</kbd> <kbd>w</kbd> <kbd>f</kbd> | `x` | Wrap selection in an anonymous function |
| <kbd>]e</kbd> / <kbd>[e</kbd> | `n` | Jump to next / previous diagnostic error |

### Fuzzy Finder (Telescope)

| Keybinding | Description |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>f</kbd> | Find files in project |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>g</kbd> | Live grep in project |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>b</kbd> | Find open buffers |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>h</kbd> | Find help tags |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>t</kbd> | Find Treesitter symbols |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>r</kbd> | Find Git repositories (`~/repos`) |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>d</kbd> | Find Zoxide directories |

### File Tree & Editor

| Keybinding | Description |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>t</kbd> | Toggle file tree (`nvim-tree`) |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>f</kbd> | Find current file in tree |
| <kbd>Space</kbd> <kbd>x</kbd> <kbd>x</kbd> | Toggle Trouble diagnostics |
| <kbd>Space</kbd> <kbd>x</kbd> <kbd>X</kbd> | Toggle Trouble buffer diagnostics |
| <kbd>Space</kbd> <kbd>c</kbd> <kbd>s</kbd> | Toggle Trouble document symbols |
| <kbd>Space</kbd> <kbd>b</kbd> <kbd>i</kbd> | Browse Nerd Font icons (`nerdy`) |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>i</kbd> | Browse recent icons |

### Git & Diff

| Keybinding | Mode | Description |
| :--- | :---: | :--- |
| <kbd>Space</kbd> <kbd>g</kbd> <kbd>g</kbd> | `n` | Open Neogit UI |
| <kbd>]c</kbd> / <kbd>[c</kbd> | `n` | Jump to next / previous git hunk |
| <kbd>Space</kbd> <kbd>h</kbd> <kbd>s</kbd> | `n`, `v` | Stage hunk (or visual selection) |
| <kbd>Space</kbd> <kbd>h</kbd> <kbd>r</kbd> | `n`, `v` | Reset hunk (or visual selection) |
| <kbd>Space</kbd> <kbd>h</kbd> <kbd>p</kbd> | `n` | Preview hunk |
| <kbd>Space</kbd> <kbd>h</kbd> <kbd>b</kbd> | `n` | Full line git blame |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>b</kbd> | `n` | Toggle inline blame |

### LSP & Code Actions

| Keybinding | Description |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>.</kbd> | LSP code action (Lspsaga) |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>n</kbd> | Incremental rename (`inc-rename`) |
| <kbd>Space</kbd> <kbd>q</kbd> | Send diagnostics to location list |

### Debugging (DAP) & Tasks

| Keybinding | Description |
| :--- | :--- |
| <kbd>F5</kbd> | DAP continue / start debugging |
| <kbd>F6</kbd> | DAP disconnect |
| <kbd>F10</kbd> | DAP step over |
| <kbd>F11</kbd> | DAP step into |
| <kbd>F12</kbd> | DAP step out |
| <kbd>Space</kbd> <kbd>b</kbd> | Toggle breakpoint |
| <kbd>Space</kbd> <kbd>o</kbd> | Toggle Overseer task runner |
| <kbd>Space</kbd> <kbd>R</kbd> | Run Overseer task template |

### Testing (Neotest)

| Keybinding | Description |
| :--- | :--- |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>t</kbd> | Run nearest test |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>s</kbd> | Run test suite (current file) |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>l</kbd> | Rerun last test |
| <kbd>Space</kbd> <kbd>s</kbd> <kbd>t</kbd> | Stop test |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>o</kbd> | Open test output |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>p</kbd> | Toggle test output panel |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>w</kbd> | Toggle test watch mode |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>s</kbd> | Toggle test summary |

---

## How to Customize & Extend

### 1. Adding a New Plugin

Thanks to `lazy.nvim`'s `{ import = 'plugins' }`, you can add plugins in two ways without having to modify `init.lua`:

#### Option A: Dedicated file (Recommended for large or standalone plugins)
Create a new file in `lua/plugins/<name>.lua`:

```lua
-- lua/plugins/flash.lua
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
  },
}
```

#### Option B: Add to an existing category file
Open the corresponding file in `lua/plugins/` (e.g. `lua/plugins/ui.lua`, `lua/plugins/coding.lua`) and add your plugin spec to the returned table:

```lua
return {
  -- Existing plugins...

  {
    'author/plugin-name',
    opts = {},
  },
}
```

### 2. Adding or Configuring an LSP Server

Open [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua):

1. **To enable a new server**, add its binary name to `vim.lsp.enable({ ... })`:
   ```lua
   vim.lsp.enable({
     -- existing servers...
     'gopls', -- added Go LSP
   })
   ```

2. **To customize server settings**, configure it above the enable list:
   ```lua
   vim.lsp.config('gopls', {
     settings = {
       gopls = {
         analyses = { unusedparams = true },
         staticcheck = true,
       },
     },
   })
   ```

3. **Styles & Preprocessor Architecture (`somesass_ls` vs `cssls`)**:
   - **SCSS / Sass (`somesass_ls`)**: Configured with dynamic path alias discovery (`before_init`) scanning `src/` to resolve `@/` imports (e.g. `@/styles/...`), ensuring full SassDoc hover previews and symbol navigation on mixins, functions, and variables.
   - **CSS Server Scoping (`cssls` & `css_variables`)**: Explicitly scoped to `css` and `less` filetypes. Because `somesass_ls` bundles the CSS language service (handling MDN documentation and custom property completions), this prevents duplicate hover dialogs and conflicting completion menus in `.scss` files while keeping CSS language features intact in `.css` files.

### 3. Adding Keymaps
- **General keymaps**: Add to [`lua/config/keymaps.lua`](lua/config/keymaps.lua).
- **Plugin-specific keymaps**: Define them directly in the plugin's spec table inside `lua/plugins/<category>.lua` using the `keys` property or within `config = function(_, opts) ... end`.

### 4. Adding Options or Autocommands
- **Vim options (`vim.o` / `vim.opt`)**: Edit [`lua/config/options.lua`](lua/config/options.lua).
- **Autocommands or User Commands**: Edit [`lua/config/autocmds.lua`](lua/config/autocmds.lua).

### 5. Local & Private Overrides (Git-Ignored)
If you have machine-specific binary paths, private API tokens, or GCP project IDs that should **never be committed to Git**:

1. Copy the template:
   ```bash
   cp lua/config/local.lua.example lua/config/local.lua
   ```
2. Set your local overrides inside [`lua/config/local.lua`](lua/config/local.lua):
   ```lua
   vim.g.vertex_project_id = 'your-actual-gcp-project-id'
   vim.g.codelldb_path = '/custom/path/to/codelldb'
   ```
   *(Alternatively, environment variables like `export VERTEX_PROJECT_ID="your-project"` are automatically respected).*

---

## Prerequisites

To take full advantage of this configuration, ensure the following are installed on your system:

| Tool | Purpose |
| :--- | :--- |
| **Neovim >= 0.12** | Core editor with native LSP completion & configs |
| **Git** | For `lazy.nvim` plugin management and git integrations |
| **C Compiler (`gcc` / `clang`) & `make`** | Compiling Treesitter parsers and `telescope-fzf-native` |
| **Cargo / Rust** | Compiling `blink.cmp` fuzzy engine and Rust development |
| **[Ripgrep](https://github.com/BurntSushi/ripgrep)** | Ultra-fast search for Telescope and Blink completion |
| **[Nerd Font](https://www.nerdfonts.com/)** | Icons for lualine, nvim-tree, and completion menu |
| **[Zoxide](https://github.com/ajeetdsouza/zoxide)** *(optional)* | Smart directory jumping integration |
| **CodeLLDB** *(optional)* | Debugger adapter for Rust/C++ in `/opt/codelldb/` |

---

## Installation

1. Backup your existing configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/fiftythanks/nvim.git ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```
   `lazy.nvim` will automatically bootstrap and install all plugins. Run `:Lazy sync` or `:checkhealth` if needed.
