# This file should contain configuration variables that are meant to be 
# shared across systems. 
# To override some configuration, use `.system-env-specific.sh`
echo "Hello from .system-env.sh"

# ------------- System Tools ------------- 
# FZF
[ -e "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Z
[ -e "$HOME/.local/bin/z.sh" ] && . "$HOME/.local/bin/z.sh"

# ----------------- Rust -----------------
# Setting up cargo
[ -e "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ---------------- NodeJS ----------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ---------------- Python ----------------
# TODO: Migrate over to pyenv everywhere (?)

# ---------------- Haskell ---------------
[ -e "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# Load any system specific overrides
if [ -e "$HOME/.system-env-specific.sh" ]; then
    echo 'Loading system specific overrides'
    . "$HOME/.system-env-specific.sh"
fi
