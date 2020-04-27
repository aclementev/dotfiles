VIMFILES
========

Files and other settings for VIM's config 
-----------------------------------------

## Setup

### Windows
  * Clone this repo under GVIM's *$HOME* location (*C:\Users\USERNAME* by
default). 
  * Create a symlink for both `.vimrc` and `_gvimrc` in the *%HOME%* directory
    and link to both `.vim/.vimrc` and `.vim/gvimrc`.
Open Command Line in Administrator mode:
```DOS
mklink %HOME%\.vimrc %HOME%\.vim\.vimrc
mklink %HOME%\_gvimrc %HOME%\.vim\gvimrc
```

### Linux
  * Clone this repo in the home directory (~)
  * Create a symlink for the .vimrc
```bash
ln -s ~/.vim/.vimrc ~/.vimrc
```

### Plugins
Vim Plug is configured in the .vimrc file, but needs to be installed manually in
each new machine using this file. However it has to be manually installed first.
To do so, run this command from anywhere:
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

After Vim Plug is installed, open vim and run:
```vim
:PlugInstall
```

For the Hack Font (Patched for powerline by default), install from [here](https://github.com/source-foundry/Hack)

#### List of plugins installed (incomplete)
  * **Vim Plug**: Plugin manager
  * **NERDTree**: Tree filesystem display
  * **FZF**: Fuzzy file finder
  * **Coc.nvim**: LSP client
