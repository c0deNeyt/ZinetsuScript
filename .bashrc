#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#Aliases
source $HOME/Script/Alias.sh
#Function
source $HOME/Script/Function.sh
#List of server IP's
source $HOME/Script/ssh.sh
# Reload config (mainly to load keybrd conf)
source ~/.config/x11/xinitrc

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

#export http_proxy="socks5://localhost:8080"
#export https_proxy="socks5://localhost:8080"
#if [[ "$HOSTNAME" == "pdsdrauto1d" ]]; then
#  alias ssh="/home/dradmin/dr_automation/config/ssh_custom.sh"
#  alias dr="$HOME/dr_automation/scripts/main.sh"
#  alias util="$HOME/dr_automation/scripts/util.sh"
#fi
export BASE_DIR="$HOME/dr_automation"

export OpenAI_KEY="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"
export GEMINI_API_KEY="AIzaSyBnKj3fqiN77Tysb4zVlUaJTmFKboSlo9Q"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
#export CUSTOM_SSH_CFG="/home/dradmin/dr_automation/config/.ssh/ssh_config"
#export PATH=$PATH:/sbin:/usr/sbin
#cd $HOME/dr_automation
alias vim='nvim'
