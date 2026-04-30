# dotfiles

My macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

<img width="1728" height="1117" alt="image" src="https://github.com/user-attachments/assets/c44a3f6c-dbf9-4edf-8d40-d7b568ccc803" />

This setup is built around a few core ideas:

- `omniwm` for a Hyprland-style tiling workflow on macOS
- `sketchybar` to replace the native menu bar with the info I actually want
- `tmux` plus `tmux-sessionizer` for fast context switching between projects
- `codex` and `claude` surfaced in the bar so usage is visible at a glance
- `ghostty`, `zsh`, and `nvim` as the terminal-first daily drivers

## What's In Here

- `omniwm/` - window manager settings, keybinds, layouts, and app rules
- `sketchybar/` - status bar config, widgets, plugins, and launch agent helpers
- `tmux/` - tmux config plus the `tmux-sessionizer` helper
- `zsh/` - shell config, prompt, aliases, and lazy-loading setup
- `ghostty/` - terminal config
- `nvim/` - Neovim config, LSP, editing workflow, and AI integration

## Install

```bash
brew bundle
stow omniwm sketchybar tmux zsh ghostty nvim
```

If you only want part of the setup, stow the packages you need individually.

## Workflow

### OmniWM

`omniwm` is the window manager layer for the desktop. The config leans into:

- tiled layouts by default
- strong window borders and visible gaps
- workspace switching with `Option+1` through `Option+4`
- `Option+Shift+<number>` for moving windows between workspaces
- a quake-style terminal for quick access

The config lives in [`omniwm/.config/omniwm/settings.toml`](omniwm/.config/omniwm/settings.toml).

### SketchyBar

`sketchybar` replaces the stock macOS menu bar with a minimal, functional status bar.

It currently surfaces:

- workspace and window state from `omniwm`
- CPU, battery, and clock info
- Claude usage
- Codex usage

The bar depends on the `font-sketchybar-app-font` cask for app icons, so make sure `brew bundle` has installed it before starting the bar.

Also you need to do 
```
chmod +x ~/Library/LaunchAgents/com.omniwm.sketchybar-watcher.plist
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

### tmux

`tmux` is configured for a fast, editor-like terminal workflow:

- `F12` is the prefix but I use [Hyperkey](https://hyperkey.app/) to rebind this to my Caps Lock, with a top-right indicator while prefix mode is active
- `Option`-free navigation and split management
- Vim-style scrollback through tmux copy mode
- `lazygit` opens in a popup
- `tmux-sessionizer` jumps between project sessions quickly

The sessionizer helper lives in [`tmux/.local/bin/tmux-sessionizer`](tmux/.local/bin/tmux-sessionizer).

Useful bindings:

- `F12` then `s` for a horizontal split
- `F12` then `v` for a vertical split
- `F12` then `g` for `lazygit`
- `F12` then `f` for the sessionizer popup
- `F12` then `m` or `[` for copy mode, then `j`/`k`, `/`, `v`, and `y` to move, search, select, and copy to the macOS clipboard

### zsh

`zsh` is set up for a practical shell-first workflow:

- standard Zsh layering with `.zshenv`, `.zprofile`, and `.zshrc`
- Oh My Zsh as the interactive shell baseline
- eager completion initialization, plus lazy-loaded `nvm`
- Atuin for searchable shell history
- Homebrew-managed `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-system-clipboard`
- aliases for `nvim`, `tmux-sessionizer`, and `lazygit`
- an OMZ-based prompt with git branch and status counts
- paths for Go, Android, Bun, Node, PostgreSQL, and local binaries

### Neovim

`nvim` is the main editor config and includes:

- LSP setup
- formatting and treesitter
- file navigation and git tooling
- AI integration

## Notes

- This repo is organized as stow packages, so each top-level directory maps to a package.
- Some configs expect local secrets or machine-specific files, such as the Claude cookie and Codex auth state.
- The SketchyBar OmniWM watcher is wired through a LaunchAgent at [`sketchybar/Library/LaunchAgents/com.omniwm.sketchybar-watcher.plist`](sketchybar/Library/LaunchAgents/com.omniwm.sketchybar-watcher.plist).
