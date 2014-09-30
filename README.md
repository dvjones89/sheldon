# Sheldon

Designed with the obsessive developer in mind, Sheldon makes it easy for you to manage your .dotfiles and configs across all your OS X / UNIX devices.  
Use whatever file sync mechanism you like (Dropbox, BitTorrent Sync) to mirror your files and have Sheldon symbolically link them with a single command.  
Choose to symlink only the files you're interested in and, where appropriate, ask Sheldon to merge your files into a single "master" that can be easily sourced.


## Installation
Write instructions for adding Sheldon.rb to user's path or, even better, concoct a nifty install script.  
Explain how the data directory is defined.



## Usage
### Creating Symbolic Links ( ```sheldon link```)
Let's say you want to symlink all of your usual .dotfiles into your home directory (/home/dave) on a new machine.
First, navigate into your home directory:

```
cd /home/dave
```

Then, ask Sheldon to create symbolic links from his data directory into your home directory. In this example, he links your .dotfiles for ZSH and Git.  

```
sheldon link  
Symlink dave/.gitconfig (y/n) ? y  
Symlink dave/.zshrc (y/n) ? y  
💥 Sheldon💥  Linking Complete
```  

This assumes the presence of "dave" directory in your Sheldon data directory.
