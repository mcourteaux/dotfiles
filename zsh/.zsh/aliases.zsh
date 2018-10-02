# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# PS
alias psa="ps aux"
alias psg="ps aux | grep "
alias psr='ps aux | grep ruby'

# Moving around
alias cdb='cd -'
alias cls='clear;ls'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

if [[ $platform == 'linux' ]]; then
  alias ll='ls -alh --color=auto'
  alias ls='ls --color=auto'
elif [[ $platform == 'darwin' ]]; then
  alias ll='ls -alGh'
  alias ls='ls -Gh'
fi

# show me files matching "ls grep"
alias lsg='ll | grep'

# Alias Editing
mkcdir ()
{
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}

alias ae='vim $yadr/zsh/aliases.zsh' #alias edit
alias ar='source $yadr/zsh/aliases.zsh'  #alias reload
alias gar="killall -HUP -u \"$USER\" zsh"  #global alias reload

# vim using
mvim --version > /dev/null 2>&1
MACVIM_INSTALLED=$?
if [ $MACVIM_INSTALLED -eq 0 ]; then
  alias vim="mvim -v"
fi

# mimic vim functions
alias :q='exit'
alias :e='vim'

# vimrc editing
alias ve='vim ~/.vimrc'

# zsh profile editing
alias ze='vim ~/.zshrc'

# Git Aliases
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

## Git Staging / Committing
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gcam='git commit --verbose --all --message'
alias grs='git reset --soft'
alias gRs='git reset --hard'
alias guncommit='git reset --soft "HEAD^"'
alias ga='git add -A'
alias gadd='git add'

## Git Merge
alias gm='git merge'
alias gmF='git moerge --no-ff'

## Git Log
export _git_log_long_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)  %C(blue)%ai (%ar)%C(reset)%n%+B'
export _git_log_medium_format='%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset'
export _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)'
alias gl='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias gll='git log --topo-order --pretty=format:"${_git_log_long_format}"'
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'
alias gls='git log --topo-order --stat --pretty=format:"${_git_log_long_format}"'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}%n"'

## Git Push / Pull
alias gp='git push'
alias gpA='git push --all && git push --tags'
alias gpl='git pull'
alias gf='git fetch'
alias gr='git remote --verbose'

## Git Submodule
alias gS='git submodule'
alias gSuir='git submodule update --init --recursive'

alias -g k='exa'
alias -g kk='exa -bl --color-scale'
alias -g kg='exa -bl --git --color-scale'
