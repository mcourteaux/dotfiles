#
# only init if installed.
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)" >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache


# jump to recently used items
alias a='LC_NUMERIC=en_US.UTF-8 fasd -a' # any
alias s='LC_NUMERIC=en_US.UTF-8 fasd -si' # show / search / select
alias d='LC_NUMERIC=en_US.UTF-8 fasd -d' # directory
alias f='LC_NUMERIC=en_US.UTF-8 fasd -f' # file
alias z='LC_NUMERIC=en_US.UTF-8 fasd_cd -d' # cd, same functionality as j in autojump
alias zz='LC_NUMERIC=en_US.UTF-8 fasd_cd -d -i' # interactive directory jump
