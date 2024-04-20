# Alacritty

Alacritty on windows has a couple of known issues.

**The mouse does not work on tmux by default**.

See this issue: https://github.com/alacritty/alacritty/issues/1663#issuecomment-1917418514

The gist is that you can copy a couple of files from the Windows Terminal project into the 
alacritty directory (`C:\Program Files\Alacritty`) and put them there.
The files are `OpenConsole.exe` and `conpty.dll`.

These will be picked up automatically by alacritty unless you configure it not to with `winpty_backend` set to `True`.

This also fixes the issue with `atuin` not processing keyboard input.
