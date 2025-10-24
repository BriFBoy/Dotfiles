
# BrifBoy`s Dotfiles

This is my personal dotfiles and are not realy meant to be used by someone else, but if you want to try them out. You can use the install scritpt called install.sh. The setup uses pywal to get colors from the wallpaper and there is an built in wallpaper switcher/theme switcher.


## Screenshots

The normal desktop
![Screenshots of the desktop](https://github.com/BriFBoy/Dotfiles/blob/readme/doc/desktop.png?raw=true)

Screenshots of inside neovim
![Screenshots of inside neovim](https://github.com/BriFBoy/Dotfiles/blob/readme/doc/in-neovim.png?raw=true)

## Usage

If you want to try out my dotfiles there is a few this that is needed.
- An clean install for the install script to work
- Or a setup with no dotfiles pre installed
you will need to manualy remove your old display manager if you try to use the install script on an existing setup.

clone the repo useing git. the install script only works if the dotfiles are located in the .dotfiles dir
```bash
  git clone --depth 1 https://github.com/BriFBoy/Dotfiles .dotfiles
```

cd into the dir and make the script runnable
```bash
  cd .dotfiles
  chmod u+x ./install.sh
```

the last thing you need to do is to run the script. you will need to enter your password to install the nessesary packages
```bash
  ./install.sh
```
