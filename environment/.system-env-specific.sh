# This file should contain configuration variables that are system specific
# 
# This file is loaded automatically by `.system-env.sh` and can be used to 
# override some defaults from there

# Graphical application setup for WSL2 
# (see https://wiki.ubuntu.com/WSL)
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1

export DAGSTER_HOME=/home/alvaro/.dagster

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Setup Starship - The prompt manager
# TODO(alvaro): Make this the default everywhere
eval "$(starship init bash)"
