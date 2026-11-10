# dotfiles

## Cloned from https://github.com/RaulMurillo/dotfiles

Preferences prevent me from wanting to fork it.


Clone using `git clone https://github.com/worthyhd/dotfiles.git`.

To symlink install run `makesymlinks.sh`. It also links every script in [bin](bin) into `~/.local/bin`.

## `dev` command

Run `dev` to pick a project from `~/dev` (fuzzy search with `fzf` if installed, otherwise a numbered menu) and open it in a tmux session with one tall pane on the left and two stacked panes on the right, all starting in the project folder. `dev <name>` skips the picker. Running it again for the same project reattaches to the existing session. Needs `tmux` (and optionally `fzf`), which `install.sh` installs.

It includes VSCode configurations, which must be installed with `install-vscode-extensions.sh` and `copy_settings.sh` from the [vscode](vscode) folder.

Also, includes the shell prompt based on [synth-shell-prompt](https://github.com/andresgongora/synth-shell-prompt). It is recommended to install *power-line fonts* and *hack-ttf* in the graphical interface accessing the system. The prompt customization can be disabled from the [bashrc](bashrc#L117).
