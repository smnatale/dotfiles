# symlink config files
stow:
    stow -R ghostty git lazygit nvim ripgrep zsh rectangle claude rex worktrunk -t $HOME
    mkdir -p ~/.claude-work
    stow -R --no-folding -d claude -t ~/.claude-work .claude
