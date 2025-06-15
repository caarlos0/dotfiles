# caarlos0/dotfiles

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
Ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles.zsh](https://github.com/caarlos0/dotfiles.zsh)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

Then, I tried nix, which seemed fine, but also overkill for my case.
In the end, what I really wanted was just a simple shell script, which is this
version here!

## Applying

```bash
./setup
```

You may also need to run:

```bash
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)
```

