# .bashrc

#Aliases
source $HOME/Script/Alias.sh
#Function
source $HOME/Script/Function.sh
#List of server IP's
source $HOME/Script/ssh.sh

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# Auto completion inside the terminal
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
 export SYSTEMD_PAGER=

# User specific aliases and functions
export PATH=$PATH:/sbin:/usr/sbin

