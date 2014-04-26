dotfiles
========

## Install

Assumes the following are installed and in your `PATH`.

  - brew [http://mxcl.github.io/homebrew/](http://mxcl.github.io/homebrew/)
  - rbenv [https://github.com/sstephenson/rbenv](https://github.com/sstephenson/rbenv)
  - coreutils [http://www.gnu.org/software/coreutils](http://www.gnu.org/software/coreutils)

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
~/.bash_tmux        # optional
~/.dircolors        # optional
~/.gemrc            # optional
~/.gitconfig        # optional
~/.gitignore_global # optional
~/.inputrc          # optional
~/.tmux.conf        # optional
```

Execute `osx/set-defaults.sh` to modify OS X settings.
