# zmodload zsh/zprof
# setopt xtrace prompt_subst
# exec 3>&2 2>/tmp/startlog.$$
# PS4='+$EPOCHREALTIME %N:%i> '

# Preference {{{

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'
setopt autocd
setopt magic_equal_subst

export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
export PURE_GIT_PULL=0
export NVM_LAZY_LOAD=true

export PATH="$HOME/.go/bin:$HOME/lib-local/bin:$HOME/lib-local/ctf-tools/bin:$PATH"

export MINICOM="-m -c on"

EDITOR='vim'

# }}}
# Keybindings & Alias {{{
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

alias ipy='ipython'
alias bpy='bpython'
alias rtr='ssh h.riat.re'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
# }}}
# Unmanaged Language Extensions {{{
# python-virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenv
source /usr/local/bin/virtualenvwrapper_lazy.sh

# Go
export GOPATH="$HOME/.go"

# NodeJS, nvm is managed by zsh-nvm
export NVM_DIR="$HOME/.nvm"

# Emscripten
export EMSDK_DIR="$HOME/lib-local/emsdk-portable"
function emcc() {
	source $EMSDK_DIR/emsdk_env.sh
	unset -f emcc
	emcc "$@"
}
[ -s "$EMSDK_DIR/emsdk_env.sh" ] || unset -f emcc
# }}}
# Unmanaged Helpers {{{
source ~/transfer.sh
#}}}
# Hacks {{{
# Overrides ssh and adjust $TERM, override xterm-termite with xterm-256color
function ssh {
    if [[ "${TERM}" == xterm-termite ]]; then
        env TERM=xterm-256color /usr/bin/ssh "$@"
    else
        /usr/bin/ssh "$@"
    fi
}

# unalias man
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
# }}}
# zgen Plugins {{{
source ~/.zgen/zgen.zsh

if ! zgen saved; then
	zgen load "willghatch/zsh-saneopt"

	export ZGEN_PREZTO_LOAD_DEFAULT=0
	zgen prezto
	zgen prezto utility

	# Plugins
	zgen load "mafredri/zsh-async" # Used by pure theme 
	zgen load "zsh-users/zsh-completions"
	zgen load "b4b4r07/enhancd"
	zgen load "zsh-users/zaw"
	# zgen load "jedahan/ripz"
	zgen load "junegunn/fzf" shell
	zgen load "knu/z"
	zgen load "andrewferrier/fzf-z"
	zgen load "lukechilds/zsh-nvm"

	# Prompt
	# zgen load "zsh-users/zsh-autosuggestions" # laggy
	zgen load "zsh-users/zsh-syntax-highlighting"
	zgen load "zsh-users/zsh-history-substring-search"
	zgen load "Riatre/pure"
	
	zgen save

	# binaries
	if ! [ -s "$HOME/.zgen/junegunn/fzf-master/bin/fzf" ]; then
		$HOME/.zgen/junegunn/fzf-master/install --bin
		echo 'export PATH=$PATH:$HOME/.zgen/junegunn/fzf-master/bin' >> $HOME/.zgen/init.zsh
	fi
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

#}}}

# unsetopt xtrace
# exec 2>&3 3>&-
# vim: set foldmethod=marker :
