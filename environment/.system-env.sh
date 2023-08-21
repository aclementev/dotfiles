# This file should contain configuration variables that are meant to be
# shared across systems.
# To override some configuration, create a `$HOME/.system-env-specific.sh`
# config file

# ----------- System Settings ------------
export EDITOR="nvim"

# Starship for zsh
source <(/usr/local/bin/starship init "$(basename $SHELL)" --print-full-init)

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
if [ -d "$HOME/code/tools/bin/" ]; then
    export PATH="$HOME/code/tools/bin:$PATH"
fi

# Z
[ -e "$HOME/.local/bin/z.sh" ] && . "$HOME/.local/bin/z.sh"

# ----------------- Rust -----------------
# Setting up cargo
[ -e "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ---------------- NodeJS ----------------
# NOTE(alvaro): This is commented out since it's very slow, use lazy loading
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ---------------- Python ----------------
# TODO: Migrate over to pyenv everywhere (?)
export WORKON_HOME=~/.virtualenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# ---------------- Haskell ---------------
[ -e "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# ---------------- BigML -----------------
[ -f "$HOME/.bigml_credentials" ] && . "$HOME/.bigml_credentials"

# Load any system specific overrides
if [ -e "$HOME/.system-env-specific.sh" ]; then
    . "$HOME/.system-env-specific.sh"
fi
