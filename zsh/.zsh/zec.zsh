
alias zsn='cd ~/zec/SilverNode/'
alias zsnb='cd ~/zec/SilverNode/build/'
alias znr='cd ~/zec/NeonRAW/'
alias znui='cd ~/zec/nui/'
alias zcol='cd ~/zec/color/'


portable_nproc() {
    OS="$(uname -s)"
    if [ "$OS" = "Linux" ]; then
        NPROCS="$(nproc --all)"
    elif [ "$OS" = "Darwin" ] || \
         [ "$(echo "$OS" | grep -q BSD)" = "BSD" ]; then
        NPROCS="$(sysctl -n hw.ncpu)"
    else
        NPROCS="$(getconf _NPROCESSORS_ONLN)"  # glibc/coreutils fallback
    fi
    echo "$NPROCS"
}

export NINJAJOBS=$(($(portable_nproc) - 2))

#alias tracy='~/zec/NeonRAW/ext/tracy/profiler/build/unix/Tracy-release'

ZEC_HOME="$HOME/zec/"
gplzec(){
  for REPO in $(ls "$ZEC_HOME")
  do
    if [ -d "$ZEC_HOME/$REPO" ]
    then
      echo "---"
      echo "--- Updating $ZEC_HOME/$REPO"
      if [ -d "$ZEC_HOME/$REPO/.git" ]
      then
        cd "$ZEC_HOME/$REPO"
        git status
        git pull
      else
        echo "--- Skipping because it doesn't look like it has a .git folder."
      fi
    fi
  done
}
