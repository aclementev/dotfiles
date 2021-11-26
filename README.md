# dotfiles
Config files for my *NIX systems.

## Other Configuration
There are some other configuration steps that must be taken manually, depending
on the platform.

### Remapping <ESC> <-> <CAPS-LOCK>

To switch `<ESC>` and `<CAPS-LOCK>`, the method depends on the platform:

* Linux-based (GNOME): install `gnome-tweaks` (`sudo apt install gnomre-tweaks`) and use the menu, it's an option in there.
* MacOS: Use `karabiner`, install it through `brew` + the provided dotfiles.

## Usage
For now the configuration files are managed using GNU Stow

To use `stow`, first install it with the distro's package manager:

```terminal
sudo apt install stow
```

Then to "install" each configuration, simply run:

```terminal
stow <app>
```


## Application Specific Instructions


### zsh
Setting up the `zsh` shell depends on the platform.

#### Installation
On MacOS it should be the default, so you can skip this section.

To setup the `zsh` shell, you first need to install it.
It should be in all the package managers:

```terminal
sudo apt install zsh
```

#### Setup
The setup is mostly done using `Oh My Zsh`.

The setup is done through a provided remote script:

```terminal
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Neovim

For my current uses of Neovim, it's better to use the latest version possible.
For that we either need a package manager that supports following `HEAD` or manually
manage it through the repository.

The simplest version is to use Homebrew, which supports this kind of use out of the box:

```terminal
brew install neovim --HEAD
```

Else, we need some manual steps:

First download the neovim source code from the git repository:

```terminal
git clone https://github.com/neovim/neovim
```

Create a target folder for the local installation.
By default I use `~/neovim` as the target.

```terminal
mkdir ~/neovim
```

The next step is actually building the source.
First you need to make sure to install the build requirements.
They are described [here](https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites),
but for Debian based systems (Debian, Ubuntu, PopOS, etc.):


```terminal
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
```

Now, setup the target for installation and start building (for more information, see [this](https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source)):

```terminal
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"  CMAKE_BUILD_TYPE=Release -j4
make install
```

And now, the `nvim` binary is created at: `~/neovim/bin/nvim`.
You need to make sure it's available in the `PATH`.
For this, you can either add this path directly to it, or more cleanly add
a symlink to a more standard bin directory:

```terminal
ln -s ~/neovim/bin/nvim ~/.local/bin/nvim
```

Now we have the binary ready to be used.
However, the current state of the configuration makes it so that neovim is not
really usable without some extra steps.

#### Post Installation

After the installation of the `nvim` binary, you need to install the `Plug` plugin manager
and install the right plugins for it to work correctly.

**Plug.vim**
This is the package manager.
This is the main applications that we need to install manually, and then this
will handle the rest.

To install it, just download the source and put it in the `autoload` folder:


```terminal
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**Plugins**
Once `Plug.vim` is set up, just run `:PlugInstall` inside a `nvim` instance and
everything should be mostly setup:

```terminal
nvim -c PlugInstall
```

There are still a couple of extra additions that are nice to have:

##### Python3 Configuration
**TODO**

##### fzy-lua-native Installation
This is C FFI extension for the lua implementation `fzy` algorithm for faster
searching (used by `Telescope`) which speeds up the fuzzy searching.

To install this:

```terminal
git clone https://github.com/romgrk/fzy-lua-native
cd fzy-lua-native
make
```

This will create a compiled binary on `static/<output>` (output depends on the platform).
You can now install it by copying it to `/usr/local/lib`:


```terminal
sudo cp static/libfzy-linux-x86_64.so /usr/local/lib/
sudo ldconfig
```

And it _should_ be ready to go (I have not checked yet though).


### Tmux

To fully install `tmux` and `tmuxinator`, you need to install first the `Tmux Plugin Manager` (TPM).
To do it, you just need to download the repository inside the `~/.tmux/plugins/tpm` directory:


```terminal
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

The rest is handled by the configuration.
The first time you open `tmux` (and any time you install a new plugin), you need
to actually run the installtion of the plugins.
For that just run `prefix + I`.
NOTE that this looks like it's doing nothing, but after a couple of seconds it should report something.
