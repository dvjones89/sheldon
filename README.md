# Sheldon

Designed with the obsessive developer in mind, Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / linux devices.  

### Usage
#### Add files/folders to Sheldon (sheldon learn)
Teach Sheldon about new files or directories using the `learn` command:
```shell
sheldon learn ~/.gitconfig
Friendly Name For File/Folder: my git config
```

Sheldon will move the original file/directory into his data directory and symlink back to it's original location.
```shell
ls -al ~ | grep .gitconfig
.gitconfig -> /Users/dave/sheldon/my git config/.gitconfig
```

#### Recall your files on other machines (sheldon recall)
Use Dropbox / RSync / Whatever to copy Sheldon's data directory onto your new machine.
Sheldon's `recall` command will symlink the file from the data directory to it's correct location on the filesystem:

```shell
sheldon recall 'my git config'

ls -al ~ | grep .gitconfig
.gitconfig -> /Users/john/sheldon/my git config/.gitconfig
```

Keep your data directory in sync across all your devices using your tool of choice, Dropbox, Google Drive, BTSync.

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
