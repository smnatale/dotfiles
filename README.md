# My Dotfiles

A collection of configuration files for the various tools and software I use, managed using GNU Stow for easy, modular, and maintainable setup via symlinks.

## Recommended Setup (macOS)

### 1. Install Homebrew
If you haven't already install [Homebrew](https://brew.sh/)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install GNU Stow
[Stow](https://formulae.brew.sh/formula/stow) allows clean structure, easy updates and effortless switching between machines using Git.
```bash
brew install stow
```

### 3. Clone this repo
Clone the `dotfiles` repository wherever you'd like
```bash
git clone https://github.com/smnatale/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 4. Stow configurations
For each directory (e.g. `nvim`, `zsh`, `wezterm`), run:
```bash
stow <directory-name>
```

This will symlink the files in that directory to your home directory.

## What's Included

- `nvim/` – My Neovim setup, fully featured with LSP, autocompletion (CMP), AI tools, and quality-of-life plugins
- `zsh/` – ZSH configuration powered by `powerlevel10k` for a sleek prompt and `zinit` for flexible plugin management
- `wezterm/` – Configuration for WezTerm, my terminal emulator of choice

## Contribution and License
Feel free to fork, clone, and adapt these dotfiles to your own needs.
