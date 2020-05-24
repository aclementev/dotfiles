#!/bin/bash

# Check that git is installed
if which git &> /dev/null
then
    # Get this script's directory
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    git clone https://github.com/tmux-plugins/tpm $DIR/plugins/tpm
    stow -d ~/dotfiles tmux
else
    echo "git must be installed to run this script"
fi
