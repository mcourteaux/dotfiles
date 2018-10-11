
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
    EXA_BIN="exa-linux-x86_64"
elif [[ $unamestr == 'Darwin' ]]; then
    EXA_BIN="exa_macos-x86_64"
fi

alias -g exa="~/.exa/$EXA_BIN"

alias -g k='exa'
alias -g kk='exa -bl --color-scale'
alias -g kg='exa -bl --git --color-scale'
alias -g kgt='exa -bl --git --color-scale --tree'
alias -g kkt='exa -bl --color-scale --tree'

