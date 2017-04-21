#zmodload zsh/zprof
#setopt xtrace prompt_subst
#exec 3>&2 2>/tmp/startlog.$$
#PS4='+$EPOCHREALTIME %N:%i> '

# # OMZ {{{
# # Path to your oh-my-zsh installation.
# export ZSH=$HOME/.oh-my-zsh

# # Set name of the theme to load.
# # Look in ~/.oh-my-zsh/themes/
# # Optionally, if you set this to "random", it'll load a random theme each
# # time that oh-my-zsh is loaded.
# ZSH_THEME="clean"

# # Uncomment the following line to use case-sensitive completion.
# # CASE_SENSITIVE="true"

# # Uncomment the following line to disable bi-weekly auto-update checks.
# # DISABLE_AUTO_UPDATE="true"

# # Uncomment the following line to change how often to auto-update (in days).
# # export UPDATE_ZSH_DAYS=13

# # Uncomment the following line to disable colors in ls.
# # DISABLE_LS_COLORS="true"

# # Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# # Uncomment the following line to enable command auto-correction.
# # ENABLE_CORRECTION="true"

# # Uncomment the following line to display red dots whilst waiting for completion.
# # COMPLETION_WAITING_DOTS="true"

# # Uncomment the following line if you want to disable marking untracked files
# # under VCS as dirty. This makes repository status check for large repositories
# # much, much faster.
# # DISABLE_UNTRACKED_FILES_DIRTY="true"

# # Uncomment the following line if you want to change the command execution time
# # stamp shown in the history command output.
# # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# # HIST_STAMPS="mm/dd/yyyy"

# # Would you like to use another custom folder than $ZSH/custom?
# # ZSH_CUSTOM=/path/to/new-custom-folder

# # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# plugins=(git catimg common-aliases debian pip sudo urltools )
# source $ZSH/oh-my-zsh.sh
# # }}}
# Prezto {{{
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# }}}
# Preference {{{

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export PATH="$PATH:$HOME/lib-local/bin:$HOME/.local/bin:$HOM/.go/bin"
export PATH="/home/riatre/lib-local/ctf-tools/bin:$PATH"
export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting
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
alias vim='nvim'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#unsetopt xtrace
#exec 2>&3 3>&-
# vim: set foldmethod=marker :

export NVM_DIR="/home/riatre/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
