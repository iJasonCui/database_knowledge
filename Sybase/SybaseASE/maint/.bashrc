# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

function proml {
local WHITE="\[\033[1;37m\]"
local NO_COLOUR="\[\033[0m\]"
local YELLOW="\[\033[1;33m\]"
local CYAN="\[\033[1;36m\]"
local GREEN="\[\033[1;32m\]"
local RED="\[\033[1;31m\]"
local MAGENTA="\[\033[1;35m\]"
local BLUE="\[\033[1;32m\]"
local SYBASE="SYBASE"
case $TERM in
    xterm*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    ansi*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    dtterm*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    *)
        TITLEBAR=""
        ;;
esac
PS1="${TITLEBAR}$YELLOW[$CYAN\u@\h$YELLOW:$RED\w$YELLOW]$WHITE\$$NO_COLOUR "
PS2='> '
PS4='+ '
}
proml
export PS1 PS2 PS4
cd

