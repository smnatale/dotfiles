# dotfiles

My macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

<img width="1728" height="1117" alt="image" src="https://github.com/user-attachments/assets/c44a3f6c-dbf9-4edf-8d40-d7b568ccc803" />

This setup is built around a few core ideas:

- `sketchybar` to replace the native menu bar with the info I actually want
- `kitty` sessions plus `kitty-sessionizer` for fast context switching between projects
- `claude` global settings for shared hooks, permissions, and formatting across all repos
- `codex` and `claude` surfaced in the bar so usage is visible at a glance
- `kitty`, `zsh`, and `nvim` as the terminal-first daily drivers

## What's In Here

- `sketchybar/` - status bar config, widgets, plugins, and launch agent helpers
- `kitty/` - terminal config plus the `kitty-sessionizer` helper
- `zsh/` - shell config, prompt, aliases, and lazy-loading setup
- `nvim/` - Neovim config, LSP, editing workflow, and AI integration
- `claude/` - Claude Code global settings, PostToolUse formatting hooks, and permissions

## Install

```bash
brew bundle
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
stow sketchybar kitty zsh nvim claude -t ~/
```

If you only want part of the setup, stow the packages you need individually. Note: run `mkdir -p ~/.claude` before stowing `claude` on a fresh machine to prevent stow from folding the directory.

To check a machine after setup:

```bash
brew bundle check
stow -n -v -t ~ zsh
```

## Workflow

### SketchyBar

`sketchybar` replaces the stock macOS menu bar with a minimal, functional status bar.

It currently surfaces:

- workspace and window state from `omniwm`
- CPU, battery, and clock info
- Claude usage
- Codex usage

The bar depends on the `font-sketchybar-app-font` cask for app icons, so make sure `brew bundle` has installed it before starting the bar.

The config is written in Lua and uses [SbarLua](https://github.com/FelixKratz/SbarLua), which must be installed separately so `require("sketchybar")` can load:

```sh
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua
make install
```

#### Claude usage widget

The Claude widget shows session and weekly usage in the bar.

It reads the `Claude Code-credentials` item from macOS Keychain, expects that item to contain JSON with an `accessToken`, and uses that token to query Anthropic's usage endpoint.

If the keychain item is missing, the widget will show an error until Claude Code has been signed in and the credentials item exists locally.

To set it up manually:

1. Open `Keychain Access`.
2. Search for `Claude Code-credentials`.
3. Open the item, go to `Access Control`, and add SketchyBar as an allowed app.
4. If you need to find the binary manually, use `Cmd+Shift+G` in Finder, jump to `/opt/homebrew/bin`, and select `sketchybar`.
5. Make sure the item still contains the Claude JSON payload, including the `accessToken`.

The widget looks for that exact item name, so keep it consistent.

#### Codex usage widget

The Codex widget reads `~/.codex/auth.json`, uses the stored access token, and displays usage percentage plus reset timing in the bar.

### Kitty

`kitty` is configured for a fast, workspace-oriented terminal workflow:

- `F12` is the prefix but I use [Hyperkey](https://hyperkey.app/) to rebind this to my Caps Lock, with a top-right indicator while prefix mode is active
- session-scoped tabs, so each workspace only shows its own terminals
- `kitty-sessionizer` jumps between open sessions and project roots with `fzf`
- new workspaces are generated as cached Kitty session files under `~/.cache/kitty-sessionizer`

The sessionizer helper lives in [`kitty/.local/bin/kitty-sessionizer`](kitty/.local/bin/kitty-sessionizer).

Useful bindings:

- `F12` then `f` for the workspace switcher
- `F12` then `c` for a new tab in the current workspace
- `F12` then `d` to close the current tab

### zsh

`zsh` is set up for a practical shell-first workflow:

- standard Zsh layering with `.zshenv`, `.zprofile`, and `.zshrc`
- Oh My Zsh as the interactive shell baseline
- eager completion initialization, plus `fnm` for Node version management
- Atuin for searchable shell history
- Homebrew-managed `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-system-clipboard`
- aliases for `nvim`, `kitty-sessionizer`, and `lazygit`
- an OMZ-based prompt with git branch and status counts
- paths for Go, Android, Bun, Node, PostgreSQL, and local binaries

Make sure `~/.oh-my-zsh` exists before expecting the full interactive shell to work. The prompt expects OMZ's `git_current_branch` helper. The Homebrew-managed zsh integrations come from the repo `Brewfile`, so `brew bundle check` should be clean before debugging shell behavior.

### Claude Code

`claude` manages the global `~/.claude/settings.json` that applies to every project:

- **PostToolUse hooks**: auto-formats on every Write/Edit — prettier+eslint for JS/TS, gofumpt+goimports for Go, stylua for Lua
- **Global permissions**: pre-approved commands for git, gh, go, npx, yarn, make, and common shell tools so agents spend less time asking for permission
- **Tmux notifications**: bell file pattern for async task completion in tmux sessions
- **Plugins**: typescript-lsp, gopls-lsp, swift-lsp, lua-lsp, playwright, frontend-design

Project-specific settings (MCP servers, specialized build commands) still live in each project's `.claude/settings.local.json`.

### Neovim

`nvim` is the main editor config and includes:

- LSP setup
- formatting and treesitter
- file navigation and git tooling
- AI integration

## Notes

- This repo is organized as stow packages, so each top-level directory maps to a package.
- Some configs expect local secrets or machine-specific files, such as the Claude cookie and Codex auth state.
