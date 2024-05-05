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
    [ -e "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"
else
    [ -e "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
fi
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden'

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
export PATH="$HOME/.local/bin:$PATH"

if [ -d "$HOME/code/tools/bin/" ]; then
    export PATH="$HOME/code/tools/bin:$PATH"
fi

# Load any system specific overrides
if [ -e "$HOME/.system-env-specific.sh" ]; then
    . "$HOME/.system-env-specific.sh"
fi
