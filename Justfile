# symlink config files
stow:
    stow ghostty git lazygit nvim ripgrep zsh rectangle claude rex -t $HOME
    mkdir -p ~/.claude-work
    stow --no-folding -d claude -t ~/.claude-work .claude
