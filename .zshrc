# zmodload zsh/zprof
# setopt xtrace prompt_subst
# exec 3>&2 2>/tmp/startlog.$$
# PS4='+$EPOCHREALTIME %N:%i> '

unsetopt BG_NICE # WSL does not support nice(5) for now.

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

  export ZGEN_PREZTO_LOAD_DEFAULT=0
  zgen prezto '*:*' color 'yes'
  zgen prezto
  zgen prezto utility
  zgen prezto completion

  # Plugins
  zgen load "junegunn/fzf" shell
  zgen load "rupa/z"
  zgen load "andrewferrier/fzf-z"
  zgen load "mafredri/zsh-async" # Used by pure theme 
  zgen load "zsh-users/zsh-completions"
  zgen load "b4b4r07/enhancd"
  zgen load "zsh-users/zaw"
  # zgen load "jedahan/ripz"
  zgen load "lukechilds/zsh-nvm"

  # Prompt
  # zgen load "zsh-users/zsh-autosuggestions" # laggy
  # zgen load "zsh-users/zsh-syntax-highlighting"
  zgen load "zdharma/fast-syntax-highlighting"
  zgen load "zsh-users/zsh-history-substring-search"
  zgen load "Riatre/pure"

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

#}}}
# Preference {{{

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='underline'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'
setopt autocd
setopt magic_equal_subst
setopt promptcr
setopt promptsp

export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
export PURE_GIT_PULL=0
export NVM_LAZY_LOAD=true

export MINICOM="-m -c on"

EDITOR='vim'

# }}}
# Keybindings & Alias {{{
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

alias ipy='ipython'
alias bpy='bpython'
alias rtr='ssh mov.eaxe.cx'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
# }}}
# Unmanaged Language Extensions {{{
# python-virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenv
[ -s "/usr/local/bin/virtualenvwrapper_lazy.sh" ] && source /usr/local/bin/virtualenvwrapper_lazy.sh

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

if [[ ! -z "${RIATRE_FROM_HOST}" ]]; then
    export DISPLAY=172.23.33.1:0
    export LIBGL_ALWAYS_INDIRECT=1
    # xset r rate 200 66
fi

# Correct WSL directory colors.
export 'LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;01:ow=34;01:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# }}}

# unsetopt xtrace
# exec 2>&3 3>&-
# vim: set foldmethod=marker :
