alias mkcd='mkdir -p -- "$1" && cd -P -- "$1"'
alias sudo="doas"

alias ls="ls -Ah --color=auto"
alias l="ls"
alias ll="ls -l"
alias c="clear"
alias ca="cat *"
alias cl="clear && ls"
alias e="exit"
alias b="cd -"
alias .="cd .."

alias grp="grep -B4 -A4 -i"
alias igrep="grep -i"
alias vgrep="grep -v"
alias gkill="pkill -f"
alias tree="tree -a"

alias x="python -m xonsh"
alias rand="echo $RANDOM | md5sum | sed -rE \"s/[^0-9a-zA-Z]//g\""
