
# We will use kitty themes if running Kitty
#if [[ ! -v KITTY_PID -and ! -v KITTY_WINDOW_ID -and ! -v SSH_CONNECTION ]] ; then
if [[ -z $KITTY_PID && -z $KITTY_WINDOW_ID && -z $SSH_CONNECTION ]]; then
    BASE16_SHELL_SET_BACKGROUND=false
    BASE16_SHELL=$HOME/.config/base16-shell/
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

