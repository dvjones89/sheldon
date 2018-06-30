# Sheldon
[![Build Status](https://travis-ci.org/dvjones89/sheldon.svg?branch=master)](https://travis-ci.org/dvjones89/sheldon)
[![Coverage Status](https://coveralls.io/repos/github/dvjones89/sheldon/badge.svg?branch=master)](https://coveralls.io/github/dvjones89/sheldon?branch=master)
[![Gem Version](https://badge.fury.io/rb/sheldon.svg)](https://badge.fury.io/rb/sheldon)

![Demo](https://user-images.githubusercontent.com/1914715/41686022-79aecb46-74da-11e8-8af2-1cda3fcc14bb.gif)  
Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / linux devices.  
The video above demonstrates adding a config file to Sheldon (`sheldon learn`) and recalling this config (`sheldon recall`) on another host.

Check out my [5 minute demo video](https://www.youtube.com/watch?v=7z2a1AmWNfU) to see more of Sheldon in action.

### Requirements:
* Ruby 1.9.3 or above.
* The `build-essential` and `ruby-dev` packages on linux systems

### Installation:
1) `gem install sheldon`
2) `sheldon setup ~/Dropbox/sheldon` to tell Sheldon where your existing data directory resides, or otherwise where a new data directory should be established.
3) Sync your data directory across all your different hosts using your preferred method (Dropbox, Google Drive, Git), so Sheldon's knowledge is available everywhere.

### How It Works
#### Add files/folders to Sheldon (sheldon learn)
Teach Sheldon about new files or directories using the `learn` command:
```shell
sheldon learn ~/.gitconfig
Recall Cue For File/Folder: my git config
```

Sheldon will move the original file/directory into his data directory and symlink the file/directory back to its original location.
```shell
ls -al ~ | grep .gitconfig
.gitconfig -> /Users/dave/Dropbox/sheldon/my git config/.gitconfig
```

#### Recall your files on other machines (sheldon recall)
Sheldon's `recall` command will symlink the file from the data directory to its correct location on any filesystem (even under different home directories):

```shell
sheldon recall "my git config"

ls -al ~ | grep .gitconfig
.gitconfig -> /home/vagrant/Dropbox/sheldon/my git config/.gitconfig
```

Pass the `-i` flag to Sheldon's `recall` command for interactive mode:
```shell
sheldon recall -i
Recall my git config (Y/N): Y
Recall my ZSH config (Y/N): Y
```

#### Open Your Configs In A Flash (sheldon open)
Want to quickly tweak that config file but can't remember where it resides on your system? No worries, Sheldon's got your back:
```shell
sheldon open "my git config"
# Your ~/.gitconfig will be opened in your $EDITOR
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
See [LICENSE](https://github.com/dvjones89/sheldon/blob/master/LICENSE)
