#zmodload zsh/zprof
#setopt xtrace prompt_subst
#exec 3>&2 2>/tmp/startlog.$$
#PS4='+$EPOCHREALTIME %N:%i> '

# Prezto {{{
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
PURE_GIT_PULL=0
# }}}
# Preference {{{

export PATH="$HOME/lib-local/bin:$HOME/lib-local/ctf-tools/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

export MINICOM="-m -c on"

EDITOR='vim'

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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# }}}
# Powerline {{{
# powerline-daemon -q

# . /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
# }}}
# Functions {{{
# Overrides ssh and adjust $TERM, override xterm-termite with xterm-256color
function ssh {
    if [[ "${TERM}" == xterm-termite ]]; then
        env TERM=xterm-256color /usr/bin/ssh "$@"
    else
        /usr/bin/ssh "$@"
    fi
}
# # }}}
# Language Extensions {{{

# OPAM configuration
# . /home/riatre/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# python-virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenv
source /usr/local/bin/virtualenvwrapper_lazy.sh

export GOPATH="/home/riatre/.go"
# }}}
# Keybindings & alias {{{
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

alias pssh-gdm="pssh -i -x \"-i /home/riatre/victims/gdm-storages/keys/id_rsa\" --host 'root@gdm-storage-1 root@gdm-storage-2 root@gdm-storage-3 root@gdm-storage-4 root@gdm-storage-5 root@gdm-storage-6'"
alias pscp-gdm="pscp -x \"-i /home/riatre/victims/gdm-storages/keys/id_rsa\" --host 'root@gdm-storage-1 root@gdm-storage-2 root@gdm-storage-3 root@gdm-storage-4 root@gdm-storage-5 root@gdm-storage-6'"

alias ipy='ipython'
alias bpy='bpython'
alias lyc='ssh l.riat.re'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
# }}}

source ~/transfer.sh

#unsetopt xtrace
#exec 2>&3 3>&-
# vim: set foldmethod=marker :

export NVM_DIR="/home/riatre/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
