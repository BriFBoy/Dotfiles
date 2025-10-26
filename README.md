
# BrifBoy`s Dotfiles

This is my personal dotfiles and are not realy meant to be used by someone else, but if you want to try them out. You can use the install scritpt called install.sh. The setup uses pywal to get colors from the wallpaper and there is an built in wallpaper switcher/theme switcher by pressing alt+space.


## Screenshots

The normal desktop
![Screenshots of the desktop](https://github.com/BriFBoy/Dotfiles/blob/readme/doc/desktop.png?raw=true)

Screenshots of inside neovim
![Screenshots of inside neovim](https://github.com/BriFBoy/Dotfiles/blob/readme/doc/in-neovim.png?raw=true)

## Installation
To install the dotfiles use the install script or install them manualy.


### Script info
If you want to try out my dotfiles there is a few this that is needed. The script ONLY works on an Arch based system.
- An Arch based system. A clean Arch install is recommended 
- An clean install for the install script to work
- Or a setup with no dotfiles pre installed
You will need to manualy remove your old display manager if you try to use the install script on an existing setup.

The script wil ask you if you want stuff that is not nessesary, but usefull in certain situations. When it asks you u can ether type "y" or press enter to exept. If you want to deny, just type anything else.

### Step by step
Clone the repo useing git. The install script only works if the dotfiles are located in the .dotfiles dir
```bash
  git clone --depth 1 https://github.com/BriFBoy/Dotfiles .dotfiles
  cd .dotfiles
```

Make the script runnable and run the script. You will need to enter your password to install some of the nessesary packages
```bash
  chmod u+x ./install.sh
  ./install.sh
  # or just run the script directly with
  bash install.sh
```
When the script is done. Reboot to aply the changes.
```bash
  reboot
```
### Note
When logging into hyprland for the first time you will need to set the wallpaper. You can do this by pressing alt+space and pressing enter to select the wallpaper.
