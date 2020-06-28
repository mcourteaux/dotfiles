
# Set $fpath
fpath=($fpath $HOME/.zsh/zfunctions/)

for config (~/.zsh/*.zsh) source $config

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

source /home/linuxbrew/.linuxbrew/Cellar/fzf/0.20.0/shell/key-bindings.zsh
