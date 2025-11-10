# History
export HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
HISTORY_IGNORE="^(sudo?) (rm )"

# Prompt
autoload -U promptinit
promptinit
prompt pure
