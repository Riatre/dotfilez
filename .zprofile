#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ -z "$BROWSER" && "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

if [[ -z "$EDITOR" ]]; then
  export EDITOR='vim'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='vim'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='less'
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/{.local,.cargo,.go}/bin
  /usr/local/{,s}bin(N)
  $path
)

if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
if [[ -z "$LESS" ]]; then
  export LESS='-F -g -i -M -R -S -w -X -z-4'
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Nix
path_to_probe=(
    /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    $HOME/.nix-profile/etc/profile.d/nix.sh
    /etc/profile.d/debuginfod.sh
    $HOME/.orbstack/shell/init.zsh
)
for fn in $path_to_probe; do
    if [[ -e "$fn" ]]; then
        . "$fn"
    fi
done
unset fn
unset path_to_probe

# FUCK OFF YOU STUPID DO NOT REPEATEDLY DUMP SHIT INTO MY SHELL RC
# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
