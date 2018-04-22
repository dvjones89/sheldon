# Sheldon
[![Build Status](https://travis-ci.org/dvjones89/sheldon.svg?branch=master)](https://travis-ci.org/dvjones89/sheldon)
[![Coverage Status](https://coveralls.io/repos/github/dvjones89/sheldon/badge.svg?branch=master)](https://coveralls.io/github/dvjones89/sheldon?branch=master)
[![Gem Version](https://badge.fury.io/rb/sheldon.svg)](https://badge.fury.io/rb/sheldon)

Designed with the obsessive developer in mind, Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / linux devices.  

### Installation:
1) `gem install sheldon`
2) `sheldon setup path/to/data-directory` to tell Sheldon where your existing data directory resides, or otherwise where a new data directory should be created.
3) Sync your data directory across all your different hosts using your preferred method (git, rsync, Dropbox, Resilio Sync), so Sheldon's knowledge is available everywhere.

### How It Works
#### Add files/folders to Sheldon (sheldon learn)
Teach Sheldon about new files or directories using the `learn` command:
```shell
sheldon learn ~/.gitconfig
Recall Cue For File/Folder: git
```

Sheldon will move the original file/directory into his data directory and symlink the file/directory back to it's original location.
```shell
ls -al ~ | grep .gitconfig
.gitconfig -> /Users/dave/sheldon/git/.gitconfig
```

#### Recall your files on other machines (sheldon recall)
Sheldon's `recall` command will symlink the file from the data directory to it's correct location on any filesystem (even under different home directories):

```shell
sheldon recall git

ls -al ~ | grep .gitconfig
.gitconfig -> /Users/john/sheldon/git/.gitconfig
```

Pass the `-i` flag to Sheldon's `recall` command for interactive mode:
```shell
sheldon recall -i
Recall git_config (Y/N): y
Recall .zshrc (Y/N): y
```

#### Build Bespoke Configs For Your Host (sheldon build)
Sometimes copying an entire config file between all your machine is overkill. What if you only want a subset of your configuration? Sheldon can help.

Split your ssh config into `config_work` and `config_personal`  
Use Sheldon `learn` and `recall` to make the appropriate `_config` files available on the appropriate hosts.  
Once the files are in the right place, use Sheldon `build` to create a single `config` file that can be easily sourced.

```shell
cd ~/.ssh

ls -l
config_dev -> /Users/dave/sheldon/ssh_config_dev/config_dev
config_personal -> /Users/dave/sheldon/ssh_config_personal/config_personal

sheldon build ~/.ssh
💥 Sheldon💥  Built .ssh

ls -l
config_dev -> /Users/dave/sheldon/ssh_config_dev/config_dev
config_personal -> /Users/dave/sheldon/ssh_config_personal/config_personal
config

source ~/.ssh/config
```

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
