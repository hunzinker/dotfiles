dotfiles
========

## Install

Assumes the following are installed and in your `PATH`.

brew [http://mxcl.github.io/homebrew/](http://mxcl.github.io/homebrew/)
rvm [https://rvm.io/](https://rvm.io/)

1. clone this repo `git clone git://github.com/hunzinker/dotfiles.git` in your home directory. Ex: `~/.dotfiles`
2. `.install.bash` backs up your existing `~/.bash_profile` to `~/.bash_profile.bak`.
3. Edit the installed files to customize.

The following files will be installed:

```
~/.bash_profile
~/.bash_colors
~/.bash_aliases
~/.bash_paths
~/.bashrc
~/.dircolors        # optional
~/.gemrc            # optional
~/.gitconfig        # optional
~/.gitignore_global # optional
~/.inputrc          # optional
```

Execute `osx/set-defaults.sh` to modify OS X settings.
