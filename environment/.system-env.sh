# This file should contain configuration variables that are meant to be
# shared across systems.
# To override some configuration, create a `$HOME/.system-env-specific.sh`
# config file

# ----------- System Settings ------------
export EDITOR="nvim"
export PATH="$PATH:$HOME/.local/bin"

# Starship for zsh
eval "$(starship init $(basename $SHELL))"

# ------------- System Tools -------------
# FZF
if [[ $(basename "$SHELL") = "zsh" ]]; then
    source <(fzf --zsh)
else
    eval "$(fzf --bash)"
fi
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# ------------- Colorscheme --------------
[ -e "$HOME/.alvaro_theme_name" ] || echo "tokyonight_storm" > $HOME/.alvaro_theme_name
export BAT_THEME=$(head -n1 $HOME/.alvaro_theme_name)

# direnv
if [[ -x "$(command -v direnv)" ]]; then
    if [[ $(basename "$SHELL") = "zsh" ]]; then
        eval "$(direnv hook zsh)"
    else
        eval "$(direnv hook bash)"
    fi
fi

# Custom tools
if [ ! -d "$HOME/.local/bin/" ]; then
    mkdir -p "$HOME/.local/bin"
fi

if [ -d "$HOME/code/tools/bin/" ]; then
    export PATH="$HOME/code/tools/bin:$PATH"
fi

# Rust
CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Load any system specific overrides
if [ -e "$HOME/.system-env-specific.sh" ]; then
    . "$HOME/.system-env-specific.sh"
fi

# Aliases
alias k=kubectl
