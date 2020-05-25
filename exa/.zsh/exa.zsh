
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
    EXA_BIN="exa-linux-x86_64"
elif [[ $unamestr == 'Darwin' ]]; then
    EXA_BIN="exa-macos-x86_64"
fi

alias exa="~/.bin/$EXA_BIN"

alias k='exa'
alias kk='exa -bl --color-scale -s modified'
alias kg='exa -bl --git --color-scale -s modified'
alias kgt='exa -bl --git --color-scale --tree -s modified'
alias kkt='exa -bl --color-scale --tree -RL3 -s modified'

