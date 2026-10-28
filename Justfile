# symlink config files
stow:
    stow ghostty git lazygit nvim ripgrep zsh rectangle claude rex -t $HOME

# fetch submodules (nvim)
init:
    git submodule update --init
