# Sheldon

Designed with the obsessive developer in mind, Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / linux devices.  

Use whatever file syncing tool you like to keep your master config directory in sync across all your machines.  

Sheldon will help you create and maintain symbolic links between your synchronised data directory and the different directories on your filesystem, where the config files need to live.

As a final trick, split your huge config into several smaller, independently linkable configs, and Sheldon can merge them together to make a single config that's relevant just to your current host.

## Installation:
1) `cd ~ && git clone git@github.com:dvjones89/sheldon.git .sheldon`

2) Add the following to your shell's .rc file, (commonly `~/.bashrc` or `~/.zshrc`):  
`alias sheldon='ruby ~/.sheldon/bin/sheldon.rb $1'`

3) Restart your shell


## Use Sheldon For Linking
1) Navigate to a directory of interest, for example your home folder (~)

2) Use `sheldon ls` and Sheldon will list any config files that he thinks could be linked here (or in a subdirectory rooted here)

3) Run `sheldon link` and he will offer to symlink any config files he knows about, ignoring files that have already been linked and fixing any broken symlinks he encounters.

## Use Sheldon To Build A Bespoke Config For Each Host
Sometimes copying an entire config file between all your machine is overkill. What if you only want a subset of your configuration? Sheldon can help.  

Let's use your `ssh_config` as an example. You might have servers you SSH into for work and servers you SSH into at home. Never the twain shall meet.

1) Split your `ssh_config` into `config_work`  and `config_personal`

2) Add these 2 files to Sheldon's brain (see "Teaching Sheldon", below)

3) Navigate to `~/.ssh` and run `sheldon link`, accepting his offer to symlink both `config_work` and `config_personal` to your `~/.ssh` directory

4) Run `sheldon build` and Sheldon will combine all your `config_*` files into a single `config` file that can be easily sourced.

## Teaching Sheldon
1) Typing `sheldon brains` shows you where Sheldon stores his intelligence. This defaults to `~/sheldon` but can be overriden using the `SHELDON_DATA_DIR` environment variable.
  
2) When you run `sheldon link`, Sheldon looks at the name of your current working directory and checks in his brain for a directory of the same name. If he finds a match, he'll offer to symlink the contents of that brain directory.

3) For example, if John wants to backup the dotfiles in his `/home/john` directory, he first needs to create a `john` directory in Sheldon's brain (`~/sheldon/john`). Now he just needs to copy his config files into the newly created `~/sheldon/john` directory.

4) Now if John moves to his home directory (`cd /home/john`) and runs `sheldon link`, Sheldon will offer to symlink all the config files that were just added to his brain (`~/sheldon/john`)