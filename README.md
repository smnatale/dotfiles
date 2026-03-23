# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package.

## Setup

```bash
# install packages
brew bundle

# stow whichever configs you want
stow nvim zsh ghostty sketchybar # etc.
```

## Sketchybar Claude Usage Widget

The sketchybar config includes a widget that displays your Claude.ai session (5h) and weekly (7d) usage in the status bar. It requires a couple of extra steps:

### 1. Compile the fetcher

```bash
swiftc sketchybar/.config/sketchybar/plugins/claude_fetch.swift \
  -o sketchybar/.config/sketchybar/plugins/claude_fetch
```

### 2. Add your Claude cookie

Create `~/.config/sketchybar/claude_cookie` with your `claude.ai` session cookie (the full `Cookie` header value). The file must include the `lastActiveOrg=` cookie so the fetcher can resolve your org ID.

```bash
echo 'sessionKey=sk-ant-...; lastActiveOrg=...' > ~/.config/sketchybar/claude_cookie
```

> This file is gitignored — never commit your cookie.
