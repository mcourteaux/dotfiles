
# Set $fpath
fpath=($fpath $HOME/.zsh/zfunctions/)

for config (~/.zsh/*.zsh) source $config

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin/"

export PATH="/usr/local/lib/nodejs/node-v16.15.0-linux-x64/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
