# Dotfiles

These are my dotfiles, and other such homedir configgery. Feel free to use anything you find here.

## Installation
```bash
git clone --bare git@github.com:anulman/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.cfg --work-tree=$HOME checkout

# The `.zsh/aliases` file will then create a `dotfiles` alias to `git` with the appropriate options.
```

## History
These were created by roughly following the process [described on Ackama's blog](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/), i.e.

	1. Create a bare repo at `~/.cfg`
	2. Alias a command to run `git` with our bare repo but with `~` as the working tree
	3. Configure the repo to not show untracked files
