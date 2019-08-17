
# Set $fpath
fpath=($fpath $HOME/.zsh/zfunctions/)

for config (~/.zsh/*.zsh) source $config

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$PATH:$HOME/bin"
