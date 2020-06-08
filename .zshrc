# zmodload zsh/zprof
# setopt xtrace prompt_subst
# exec 3>&2 2>/tmp/startlog.$$
# PS4='+$EPOCHREALTIME %N:%i> '

bindkey -e
(( $+functions[add-zsh-hook] )) || autoload -Uz add-zsh-hook
# Plugin Preferences {{{

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'
export PURE_GIT_PULL=0
export NVM_LAZY_LOAD=true
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
export _Z_NO_PROMPT_COMMAND=yes

# }}}
# zgen Plugins {{{
# Load zgen only if a user types a zgen command
zgen () {
	if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
		git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
	fi
	source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	zgen "$@"
}

if [[ -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
else
  zgen load "willghatch/zsh-saneopt"

  export ZGEN_PREZTO_REPO=Riatre/prezto
  export ZGEN_PREZTO_LOAD_DEFAULT=0
  zgen prezto '*:*' color 'yes'
  zgen prezto
  zgen prezto utility
  zgen prezto completion

  # Plugins
  zgen load "junegunn/fzf" shell/completion.zsh
  zgen load "junegunn/fzf" shell/key-bindings.zsh
  zgen load "rupa/z"
  zgen load "andrewferrier/fzf-z"
  zgen load "mafredri/zsh-async" # Used by pure theme 
  zgen load "zsh-users/zsh-completions"
  zgen load "zsh-users/zaw"
  zgen load "lukechilds/zsh-nvm"

  # Prompt
  # zgen load "zsh-users/zsh-autosuggestions" # laggy
  zgen load "zdharma/fast-syntax-highlighting"
  zgen load "zsh-users/zsh-history-substring-search"
  zgen load "Riatre/pure"

  # Troubleshooting
  zgen load "romkatv/zsh-prompt-benchmark"

  zgen save

  # binaries
  if ! [ -s "$HOME/.zgen/junegunn/fzf-master/bin/fzf" ]; then
    $HOME/.zgen/junegunn/fzf-master/install --bin
  fi
  export PATH=$PATH:$HOME/.zgen/junegunn/fzf-master/bin
  echo 'export PATH=$PATH:$HOME/.zgen/junegunn/fzf-master/bin' >> $HOME/.zgen/init.zsh
fi
#}}}
# History {{{

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# From romkatv/zsh4humans
function -z4h-with-local-history() {
    local last=$LASTWIDGET
    zle .set-local-history -n $1
    shift
    {
          () { local -h LASTWIDGET=$last; "$@" } "$@"
      } always {
        zle .set-local-history -n 0
    }
    return 0
}
zle -N -- -with-local-history
function z4h-up-local-history() {
  -z4h-with-local-history 1 history-substring-search-up "$@"
}
function z4h-down-local-history() {
  -z4h-with-local-history 1 history-substring-search-down "$@"
}
function z4h-up-global-history() {
  -z4h-with-local-history 0 history-substring-search-up "$@"
}
function z4h-down-global-history() {
  -z4h-with-local-history 0 history-substring-search-down "$@"
}
zle -N z4h-up-local-history
zle -N z4h-down-local-history
zle -N z4h-up-global-history
zle -N z4h-down-global-history

#}}}
# Preference {{{

setopt autocd
setopt magic_equal_subst
setopt promptcr
setopt promptsp

export MINICOM="-m -c on"

# }}}
# Keybindings & Alias {{{
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg
bindkey '^[OA' z4h-up-local-history
bindkey '^[OB' z4h-down-local-history
bindkey -M emacs '^P' z4h-up-local-history
bindkey -M emacs '^N' z4h-down-local-history
bindkey '^[[1;5A' z4h-up-global-history
bindkey '^[[1;5B' z4h-down-global-history

alias ipy='ipython'
alias bpy='bpython'
alias rtr='ssh mov.eaxe.cx'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
alias factorz='python -m primefac'
alias bazel='bazelisk'
alias vol='python ~/lib-local/volatility/vol.py'

function mkcd() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories mkcd

# fd-find in Debian is named /usr/bin/fdfind
if (( $+commands[fdfind] && ! ($+commands[fd]) )); then
    alias fd=fdfind
fi

# }}}
# Dev {{{
# python-virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenv
(( $+commands[virtualenvwrapper_lazy.sh] )) && source virtualenvwrapper_lazy.sh

# Go
export GOPATH="$HOME/.go"

# NodeJS, nvm is managed by zsh-nvm
export NVM_DIR="$HOME/.nvm"

source ~/transfer.sh

# direnv
# optional bootstrap: $SUDO apt install direnv
if (( $+commands[direnv] )) && ! (( $+functions[_direnv_hook] )); then
    eval "$(direnv hook zsh)"
    (( $+functions[_direnv_hook] )) || echo "broken direnv: no _direnv_hook function after init"
    add-zsh-hook -d precmd _direnv_hook

    function _self_destruct_direnv_hook {
        _direnv_hook
        # remove self from precmd
        precmd_functions=(${(@)precmd_functions:#_self_destruct_direnv_hook})
        builtin unfunction _self_destruct_direnv_hook
    }
    precmd_functions=(_self_destruct_direnv_hook ${precmd_functions[@]})
fi
# }}}
# Hacks {{{
# Overrides ssh and adjust $TERM, override xterm-termite with xterm-256color
function ssh {
    if [[ "${TERM}" == xterm-termite ]]; then
        env TERM=xterm-256color /usr/bin/ssh "$@"
    else
        /usr/bin/ssh "$@"
    fi
}

unalias man
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

_z_chpwd_handler() {
  (_z --add "${PWD:a}" &)
}

add-zsh-hook chpwd _z_chpwd_handler

# Dedup $PATH again, it's way easier than fixing all the scripts (nix.sh etc)
typeset -aU path

# }}}

# unsetopt xtrace
# exec 2>&3 3>&-
# vim: set foldmethod=marker :
