# Sheldon

Designed with the obsessive developer in mind, Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / linux devices.  

### How It Works
#### Add files/folders to Sheldon (sheldon learn)
Teach Sheldon about new files or directories using the `learn` command:
```shell
sheldon learn ~/.gitconfig
Recall Cue For File/Folder: git
```

Sheldon will move the original file/directory into his data directory (defaults to `~/sheldon`) and symlink back to it's original location.
```shell
ls -al ~ | grep .gitconfig
.gitconfig -> /Users/dave/sheldon/git/.gitconfig
```
Keep Sheldon's data directory synchronised across all your devices using your tool of choice, Dropbox, Google Drive, BTSync.

#### Recall your files on other machines (sheldon recall)
Sheldon's `recall` command will symlink the file from the data directory to it's correct location on any filesystem (even under different home directories):

```shell
sheldon recall git

ls -al ~ | grep .gitconfig
.gitconfig -> /Users/john/sheldon/git/.gitconfig
```

#### Build Bespoke Configs For Your Host (sheldon build)
Sometimes copying an entire config file between all your machine is overkill. What if you only want a subset of your configuration? Sheldon can help.

Split your ssh config into `config_work` and `config_personal`

Use Sheldon `learn` and `recall` to make the appropriate `_config` files available on the appropriate hosts.

Once the files are in the right place, use Sheldon `build` to create a single `config` file that can be easily sourced.

```shell
sheldon build ~/.ssh
💥 Sheldon💥  Built .ssh

source ~/.ssh/config
```

### Installation:
1) `cd ~ && git clone https://github.com/dvjones89/sheldon.git .sheldon`

2) Add the following to your shell's .rc file, (commonly `~/.bashrc` or `~/.zshrc`):  
`alias sheldon='ruby ~/.sheldon/bin/launcher'`

3) Add your .dotfiles to `~/sheldon` or point Sheldon to a different directory using the `SHELDON_DATA_DIR` environment variable.

4) Restart your shell

### Isn't This Just Homesick?
Yes, yes it is. Unfortunately, I'd written 90% of Sheldon before I discovered the awesome [homesick](https://github.com/technicalpickles/homesick) so I decided to keep going.  
Sheldon's `build` command is (as far as I know) unique to Sheldon and will perhaps prove useful to those who chunk their configs.  
If nothing else, I hope this code will be a good point of reference for other developers (and indeed my future self).

### Contributing

1. Fork it ( https://github.com/[your-github-username]/sheldon/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure you haven't broken anything `bundle exec rspec`
5. Add your own specs for your new feature
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request

### License
See LICENSE
