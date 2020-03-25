#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc oh-my-zsh private scrotwm.conf Xresources"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        # sudo chmod +x oh_my_zsh_install.sh
        # sh oh_my_zsh_install.sh
        git clone https://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Clone powerlevel10k if not already present
    if [[ ! -d $dir/oh-my-zsh/themes/powerlevel10k ]] && [[ ! -d $/dir/oh-my-zsh/custom/themes/powerlevel10k ]]; then
        echo "Cloning powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
        echo "Done"
    fi
    # Clone syntax highlighting if not already present
    if [[ ! -d $dir/oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
        echo "Cloning zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        echo "Done"
    fi
    # Clone autosuggestions if not already present
    if [[ ! -d $dir/oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
        echo "Cloning zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        echo "Done"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        echo "Changing default shell from $SHELL to zsh"
        chsh -s $(which zsh)
        echo "Done"
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

link_scripts () {
echo "Linking Scripts to /usr/bin"
for script in ~/dotfiles/scripts/*; do
	name="$(basename -- $script)"
	if [[ ! -f /usr/bin/"$name" ]]; then
		echo "$name" is not in /usr/bin. Creating symlink...
		sudo chmod +x "$script"
		sudo ln -s "$script" /usr/bin/"$name"

	fi
	echo "$script"
done
}

install_zsh
link_scripts
echo "Source your ~/.zhrc file to see the changes!"

