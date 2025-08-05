## <center>The Ultimate NeoVim Config for [Colemak](https://colemak.com/) Users</center>
<center><a href="https://instaboard.page/gh-sponsor"><img src="https://user-images.githubusercontent.com/8187501/232345609-366fd597-8a32-4667-9e80-2487ebe6f7f6.png" alt="Sponsored by Instaboard"></img></a></center>
<br/>

> 🎉 **Major Update**: This configuration has been completely refactored with a modern architecture, reducing from 80+ files to 21 core files while maintaining all functionality!

```bash
# Install language servers
npm i -g vscode-langservers-extracted
npm install -g @ansible/ansible-language-server
```

<center><img src="https://raw.githubusercontent.com/theniceboy/nvim/master/demo.png"></center>

[中文版](./README_cn.md)

Please **DO NOT** just copy this configuration folder without really looking at it! Please, at least, read this README file!

## Modern Architecture

This Neovim configuration now uses a highly unified modular architecture with:

- **Unified Design**: Centralized configuration management by functionality
- **Flat Architecture**: Simplified directory structure
- **High Performance**: Optimized file loading and startup time
- **Development Tools**: Complete toolchain including LSP, DAP, Git, AI assistant
- **Multi-language Support**: Flutter, Go, Lua, Markdown, etc.
- **Smart Navigation**: File search, symbol jumping, project management

### Core Structure
```
nvim/
├── init.lua                 # Main entry
├── lua/config/             # Configuration modules
│   ├── defaults.lua        # Default loader
│   ├── keymaps.lua        # Key mappings
│   ├── plugins.lua        # Plugin management
│   ├── lsp.lua           # LSP configuration
│   ├── autocomplete.lua   # Autocomplete
│   └── ...               # Other modules
└── lua/plugin/            # Custom plugins
```

## Requirements

- Neovim >= 0.9.0 (Required)
- Git (for plugin management)
- A modern terminal with true color support
- [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js >= 14.14 (for LSP)
- Python >= 3.8 (for some plugins)
- ripgrep (for text search)
- fd (for file finding)
- lazygit (for Git operations)

### Optional Dependencies

- xclip/pbcopy (for system clipboard support)
- Node.js packages:
  ```bash
  # LSP servers
  npm install -g typescript typescript-language-server
  npm install -g vscode-langservers-extracted
  npm install -g @ansible/ansible-language-server
  ```
- Python packages:
  ```bash
  # Python support
  pip install pynvim
  pip install python-lsp-server
  ```
- Lua LSP:
  ```bash
  # macOS
  brew install lua-language-server
  # Linux
  # See https://github.com/sumneko/lua-language-server
  ```

### Recommended Tools

- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [delta](https://github.com/dandavison/delta) - Git diff viewer
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smart directory jumper
- [yazi](https://github.com/sxyazi/yazi) - Terminal file manager

## Installation

1. Back up your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

2. Clone this repository:
```bash
git clone https://github.com/theniceboy/nvim.git ~/.config/nvim
```

3. Install the required dependencies:
```bash
# Python support
pip install pynvim

# Node.js support
npm install -g neovim

# Clipboard support (Linux/macOS)
# Linux
sudo apt install xclip   # Debian/Ubuntu
sudo pacman -S xclip    # Arch Linux
# macOS
brew install pbcopy

# Optional but recommended
brew install ripgrep fd  # Fast search tools
```

4. Start Neovim:
```bash
nvim
```
The plugin manager will automatically install all plugins on first launch.

## Configuration

### Machine-Specific Settings
Create a `lua/machine_specific.lua` file for your local settings:

```lua
-- Example machine_specific.lua
return {
  python3_host_prog = '/path/to/python3',
  node_host_prog = '/path/to/node',
  -- Add other machine-specific settings
}
```

### Language Servers
This config uses native LSP. Servers are managed through [mason.nvim](https://github.com/williamboman/mason.nvim).

To install language servers:
1. Open Neovim
2. Run `:Mason`
3. Press `i` to install servers you need

Common language servers:
```bash
# JavaScript/TypeScript
npm i -g typescript typescript-language-server

# Python
pip install python-lsp-server

# Lua
brew install lua-language-server  # macOS
```

### Key Customization
Edit `lua/config/keymaps.lua` to customize key mappings:

```lua
-- Example: Change leader key
vim.g.mapleader = " "  -- Space as leader key

-- Add custom keymaps
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true })
```

## Keyboard Shortcuts
### 1 Basic Editor Features
#### 1.1 The Most Basics
**`k`** : switchs to **`INSERT`** : mode (same as key `i` in vanilla vim)

**`Q`** : quits current vim window (same as command `:q` in vanilla vim)

**`S`** : saves the current file (same as command `:w` in vanilla vim)

**_IMPORTANT_**

  Since the `i` key has been mapped to `k`, every command (combination) that involves `i` should use `k` instead (for example, `ciw` should be `ckw`).

#### 1.2 Remapped Cursor Movement
| Shortcut   | Action                                                    | Equivalent |
|------------|-----------------------------------------------------------|------------|
| `u`        | Cursor up a terminal line                                 | `k`        |
| `e`        | Cursor down a terminal line                               | `j`        |
| `n`        | Cursor left                                               | `h`        |
| `i`        | Cursor right                                              | `l`        |
| `U`        | Cursor up 5 terminal lines                                | `5k`       |
| `E`        | Cursor down 5 terminal lines                              | `5j`       |
| `N`        | Cursor to the start of the line                           | `0`        |
| `I`        | Cursor to the end of the line                             | `$`        |
| `Ctrl` `u` | Move the view port up 5 lines without moving the cursor   | `Ctrl` `y` |
| `Ctrl` `e` | Move the view port down 5 lines without moving the cursor | `Ctrl` `e` |
| `h`        | Move to the end of this word                              | `e`        |
| `W`        | Move cursor five words forward                            | `5w`       |
| `B`        | Move cursor five words forward                            | `5b`       |

#### 1.3 Remapped Insert Mode Keys
| Shortcut   | Action                                                               |
|------------|----------------------------------------------------------------------|
| `Ctrl` `a` | Move cursor to the end of the line                                   |
| `Ctrl` `u` | Move the character on the right of the cursor to the end of the line |

#### 1.4 Remapped Text Manipulating Commands in Normal Mode
| Shortcut        | Action                                |
|-----------------|---------------------------------------|
| `l`             | **undo**                              |
| `<`             | Un-indent                             |
| `>`             | Indent                                |
| `SPACE` `SPACE` | Goto the next placeholder (`<++>`)    |

#### 1.5 Other Useful Normal Mode Remappings
| Shortcut        | Action                                         |
|-----------------|------------------------------------------------|
| `r`             | **Compile/Run the current file**               |
| `SPACE` `s` `c` | Toggle spell suggestion a                      |
| `SPACE` `d` `w` | Find adjacent duplicated word                  |
| `SPACE` `t` `t` | Convert every 4 Spaces to a tab                |
| `SPACE` `o`     | Fold                                           |
| `SPACE` `-`     | Previous quick-fix position                    |
| `SPACE` `+`     | Next quick-fix position                        |
| `\` `p`         | Show the path of the current file              |
| `SPACE` `/`     | Create a new terminal below the current window |

#### 1.6 Remapped Commands in Visual Mode
| Shortcut        | Action                                 |
|-----------------|----------------------------------------|
| `Y`             | Copy selected text to system clipboard |


### 2 Window Management
#### 2.1 Creating Window Through Split Screen
| Shortcut    | Action                                                                      |
|-------------|-----------------------------------------------------------------------------|
| `s` `u`     | Create a new horizontal split screen and place it above the current window  |
| `s` `e`     | Create a new horizontal split screen and place it below the current window  |
| `s` `n`     | Create a new vertical split screen and place it left to the current window  |
| `s` `i`     | Create a new vertical split screen and place it right to the current window |
| `s` `v`     | Set the two splits to be vertical                                           |
| `s` `h`     | Set the two splits to be horizontal                                         |
| `s` `r` `v` | Rotate splits and arrange splits vertically                                 |
| `s` `r` `h` | Rotate splits and arrange splits horizontally                               |

#### 2.2 Moving the Cursor Between Different Windows
| Shortcut      | Action                         |
|---------------|--------------------------------|
| `SPACE` + `w` | Move cursor to the next window |
| `SPACE` + `n` | Move cursor one window left    |
| `SPACE` + `i` | Move cursor one window right   |
| `SPACE` + `u` | Move cursor one window up      |
| `SPACE` + `e` | Move cursor one window down    |

#### 2.3 Resizing Different Windows
Use the arrow keys to resize the current window.

#### 2.4 Closing Windows
| Shortcut    | Action                                                                                                     |
|-------------|------------------------------------------------------------------------------------------------------------|
| `Q`         | Close the current window                                                                                   |
| `SPACE` `q` | Close the window below the current window. (The current window will be closed if there is no window below) |

### 3 Tab Management
| Shortcut    | Action           |
|-------------|------------------|
| `t` `u`     | Create a new tab |
| `t` `n`     | Go one tab left  |
| `t` `i`     | Go One tab right |
| `t` `m` `n` | Move tab left    |
| `t` `m` `i` | Move tab right   |

### 4 Terminal Keyboard Shortcuts
| Shortcut    | Action                                                      |
|-------------|-------------------------------------------------------------|
| `Ctrl` `n`  | Escape from terminal input mode                             |

## Plugin System

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management, with 72 carefully selected plugins organized into 6 categories:

### 🎨 UI Plugins (15)
- **Themes**: gruvbox, onedark, etc.
- **Status Line**: lualine.nvim
- **Tab Line**: bufferline.nvim
- **Window Bar**: Custom window title bar
- **Scroll Bar**: Smart scrollbar
- **Notifications**: nvim-notify

### ✏️ Editing Plugins (9)
- **Comments**: nvim-comment
- **Surround**: nvim-surround
- **Multi-cursor**: vim-visual-multi
- **Editor Tools**: Various editing enhancements
- **Autopairs**: Auto-pairing plugin
- **Move**: Code block movement plugin

### 🛠️ Development Tools (22)
- **LSP**: nvim-lspconfig + mason.nvim
- **Treesitter**: nvim-treesitter
- **Git**: gitsigns, lazygit
- **Copilot**: github-copilot
- **Completion**: nvim-cmp
- **Package Manager**: mason

### 🧭 Navigation (7)
- **Telescope**: fuzzy finder core
- **FZF**: high-performance search
- **Search Tools**: Enhanced searching
- **File Manager**: yazi.nvim
- **Command Palette**: commander.nvim

### 🌐 Language Support (7)
- **Markdown**: Enhanced support
- **LaTeX**: VimTeX
- **Lua**: Enhanced development

### 🔧 Utilities (9)
- **CSV**: File handling
- **Command Line**: wilder.nvim
- **Startup Time**: Analysis
- **Indent**: Visualization
- **File Types**: Enhanced detection

## Plugins Keybindings (Screenshots/GIF provided!)
### Auto-completion

This configuration uses [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) as the completion engine, providing a smart and fast completion experience.

#### Completion Sources
- LSP completion
- Buffer completion
- Path completion
- Snippet completion (using LuaSnip)
- Command line completion
- Spell checking completion

#### Completion Keybindings
| Key Binding   | Action                |
|--------------|----------------------|
| `<CR>`       | Confirm Selection    |
| `<Tab>`      | Next Candidate       |
| `<S-Tab>`    | Previous Candidate   |
| `<C-e>`      | Cancel Completion    |
| `<C-u>`      | Scroll Docs Up      |
| `<C-d>`      | Scroll Docs Down    |
| `<C-Space>`  | Trigger Completion   |

#### Snippets
Using [LuaSnip](https://github.com/L3MON4D3/LuaSnip) for snippet management:

| Key Binding | Action                |
|------------|----------------------|
| `<C-k>`    | Expand Snippet       |
| `<C-j>`    | Next Placeholder     |
| `<C-h>`    | Previous Placeholder |

#### Features
- Smart context awareness
- Real-time fuzzy matching
- Type-aware completion
- Auto-import completion
- Parameter hints
- Snippet integration
- Custom sorting

#### [coc-snippets](https://github.com/neoclide/coc-snippets)
| Shortcut   | Action                                           |
|------------|--------------------------------------------------|
| `Ctrl` `e` | Expand a snippet                                 |
| `Ctrl` `n` | (in snippet) Previous Cursor position in snippet |
| `Ctrl` `e` | (in snippet) Next Cursor position in snippet     |

![GIF Demo](https://raw.github.com/SirVer/ultisnips/master/doc/demo.gif)

### File Navigation

#### Telescope - Fuzzy Finder
[Telescope](https://github.com/nvim-telescope/telescope.nvim) is a highly extendable fuzzy finder.

| Key Binding     | Action                |
|-----------------|----------------------|
| `<leader>ff`    | Find Files           |
| `<leader>fg`    | Live Grep            |
| `<leader>fb`    | Find Buffers         |
| `<leader>fh`    | Find Help            |
| `<leader>fs`    | Find Symbols         |
| `<leader>fo`    | Recent Files         |
| `<leader>fc`    | Execute Command      |

In Telescope window:
- `<C-u>`/`<C-d>`: Scroll preview
- `<C-q>`: Send to quickfix
- `<Tab>`: Select multiple items
- `<C-v>`/`<C-x>`: Open in vertical/horizontal split

#### File Browser
This configuration provides two file browser options:

1. [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
   - Press `<leader>e` to open file tree
   - In the file tree:
     - `a`: Add file/directory
     - `d`: Delete
     - `r`: Rename
     - `y`: Copy path
     - `x`: Cut
     - `p`: Paste
     - `c`: Copy
     - `?`: Show help

2. [Yazi](https://github.com/sxyazi/yazi)
   - Press `<leader>ra` to open terminal file manager
   - Modern terminal file manager
   - Image preview support
   - Fast file operations



### Text Editing Plugins
#### [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
| Shortcut        | Action            |
|-----------------|-------------------|
| `SPACE` `t` `m` | Toggle table mode |
| `SPACE` `t` `r` | Realign table     |

See `:help table-mode.txt` for more.

#### [Undotree](https://github.com/mbbill/undotree)
| Shortcut      | Action        |
|---------------|---------------|
| `Shift` + `



### LSP Keybindings
| Key Binding     | Action                |
|-----------------|----------------------|
| `gd`            | Go to Definition     |
| `gr`            | Find References      |
| `K`             | Hover Documentation  |
| `<leader>rn`    | Rename              |
| `<leader>ca`    | Code Action         |
| `[d`            | Previous Diagnostic  |
| `]d`            | Next Diagnostic      |
| `<leader>f`     | Format Code         |
| `<leader>e`     | Show Diagnostics    |
| `<leader>o`     | Outline/Symbols     |

### Completion Keybindings
| Key Binding   | Action                |
|--------------|----------------------|
| `<CR>`       | Confirm Selection    |
| `<Tab>`      | Next Candidate       |
| `<S-Tab>`    | Previous Candidate   |
| `<C-e>`      | Cancel Completion    |
| `<C-u>`      | Scroll Docs Up      |
| `<C-d>`      | Scroll Docs Down    |
| `<C-Space>`  | Trigger Completion   |

### Git Integration

This configuration provides comprehensive Git workflow support:

#### [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)
Press `<leader>gg` to open lazygit interface, providing:
- Complete Git repository management
- Branch operations and merging
- Commit history browsing
- File status management
- Conflict resolution

#### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
Real-time Git status display:

| Key Binding     | Action                |
|-----------------|----------------------|
| `]c`            | Next Change          |
| `[c`            | Previous Change      |
| `<leader>hp`    | Preview Changes      |
| `<leader>hs`    | Stage Hunk           |
| `<leader>hu`    | Undo Stage           |
| `<leader>hr`    | Reset Hunk           |
| `<leader>hb`    | Show Line Blame      |

Features:
- Line-level Git status
- Real-time change indicators
- Hunk-level operations
- Git blame integration
- Hunk history preview

#### [diffview.nvim](https://github.com/sindrets/diffview.nvim)
Powerful diff viewer:

| Key Binding     | Action                |
|-----------------|----------------------|
| `<leader>gd`    | Open Diff View       |
| `<leader>gh`    | View File History    |

Features:
- Side-by-side diff comparison
- File history browsing
- Commit history viewing
- Merge conflict handling