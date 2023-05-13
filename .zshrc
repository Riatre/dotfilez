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
if (( ${+commands[zoxide]} )); then
    _USE_ZOXIDE=1
fi

# }}}
# zgen Plugins {{{
# Load zgen only if a user types a zgen command
zgen () {
    if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
        ZGEN_COMMIT="76492ebc701fdcb7a48ae7c95a810cd6f55d5906"
        zgen_dir="${ZDOTDIR:-${HOME}}/.zgen"
        git init --initial-branch master "${zgen_dir}"
        git -C "${zgen_dir}" remote add origin https://github.com/tarjoilija/zgen.git
        git -C "${zgen_dir}" fetch --depth 1 origin "${ZGEN_COMMIT}"
        git -C "${zgen_dir}" checkout --recurse-submodules FETCH_HEAD
    fi
    source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
    zgen "$@"
}

if [[ -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zgen/init.zsh
else
  # Prezto do compinit for us.
  export ZGEN_AUTOLOAD_COMPINIT=0
  zgen load "willghatch/zsh-saneopt" saneopt.plugin.zsh 8ec7ce0387309dcdb72b71ac85edc8799aa42792

  export ZGEN_PREZTO_REPO=Riatre/prezto
  export ZGEN_PREZTO_BRANCH=9156b35ee4886b3e9ef35e821da58ab723139432
  export ZGEN_PREZTO_LOAD_DEFAULT=0
  zgen prezto '*:*' color 'yes'
  zgen prezto
  zgen prezto utility
  zgen prezto completion

  # Plugins
  # fzf 0.38.0
  FZF_COMMIT_SHA1="352ea072269dfe2a3c429785a95a2f22887ccda3"
  zgen load "junegunn/fzf" shell/completion.zsh "$FZF_COMMIT_SHA1"
  zgen load "junegunn/fzf" shell/key-bindings.zsh "$FZF_COMMIT_SHA1"
  if [[ ! -v _USE_ZOXIDE ]]; then
      zgen load "rupa/z" / b82ac78a2d4457d2ca09973332638f123f065fd1
      zgen load "andrewferrier/fzf-z" / 37c655b2b3f488b88281cda4538292ffab6fd1e7
  fi
  zgen load "zsh-users/zsh-completions" / 449cc702dc0363cd8fc37cc2d1fdb422f6d4d0e8
  zgen load "zsh-users/zaw" / c8e6e2a4244491a2b89c2524a2030336be8d7c7f
  zgen load "lukechilds/zsh-nvm" / dda8bb6165553b17d997df29dcfa663668608178
  zgen load "spwhitt/nix-zsh-completions" / 6a1bfc024481bdba568f2ced65e02f3a359a7692

  # Prompt
  # zgen load "zsh-users/zsh-autosuggestions" # laggy
  zgen load "zsh-users/zsh-history-substring-search" / 400e58a87f72ecec14f783fbd29bc6be4ff1641c
  PURE_COMMIT_SHA1=f04e98a19cd9178ad1dd64c4f62351a06065bedb
  zgen load "Riatre/pure" async.zsh "$PURE_COMMIT_SHA1"
  zgen load "Riatre/pure" pure.zsh "$PURE_COMMIT_SHA1"
  zgen load "Riatre/wezterm-shell-integration" assets/shell-integration/wezterm.sh 013fdc4d26cd8728678319ea6383e170e8bfe924
  zgen load "zdharma-continuum/fast-syntax-highlighting" / 13d7b4e63468307b6dcb2dadf6150818f242cbff

  # Troubleshooting
  # zgen load "romkatv/zsh-prompt-benchmark"

  zgen save

  # binaries
  if ! [ -s "$HOME/.zgen/junegunn/fzf-$FZF_COMMIT_SHA1/bin/fzf" ]; then
    "$HOME/.zgen/junegunn/fzf-$FZF_COMMIT_SHA1/install" --bin
  fi
  if [[ -v _USE_ZOXIDE ]]; then
      zoxide init zsh --hook pwd >> "${ZDOTDIR:-${HOME}}/.zgen/init.zsh"
  fi
fi

export PATH="$PATH:$HOME/.zgen/junegunn/fzf-$FZF_COMMIT_SHA1/bin"
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

# Fzf with multi-select from https://github.com/junegunn/fzf/pull/2098
#
sane-fzf-history-widget() {
  local selected num selected_lines selected_line selected_line_arr
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

  # Read history lines (split on newline) into selected_lines array.
  selected_lines=(
    "${(@f)$(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} -m" $(__fzfcmd))}"
  )
  local ret=$?

  # Remove empty elements, converting ('') to ().
  selected_lines=($selected_lines)
  if [[ "${#selected_lines[@]}" -ne 0 ]]; then
    local -a history_lines=()
    for selected_line in "${selected_lines[@]}"; do
      # Split each history line on spaces, and take the 1st value (history line number).
      selected_line_arr=($=selected_line)
      num=$selected_line_arr[1]
      if [[ -n "$num" ]]; then
        # Add history at line $num to history_lines array.
        history_lines+=( "$(fc -ln $num $num)" )
      fi
    done
    # Set input buffer to newline-separated list of history lines.
    # Use echo to unescape, e.g. \n to newline, \t to tab.
    BUFFER="$(echo ${(F)history_lines})"
    # Move cursor to end of buffer.
    CURSOR=$#BUFFER
  fi

  zle reset-prompt
  return $ret
}
zle -N sane-fzf-history-widget

#}}}
# Preference {{{

setopt autocd
setopt autopushd pushdsilent pushdignoredups
setopt magic_equal_subst
setopt promptcr
setopt promptsp

export MINICOM="-m -c on"

function -z4h-redraw-prompt() {
    zle .reset-prompt
    zle -R
}
zle -N -- -z4h-redraw-prompt
function -z4h-cd-rotate() {
    {
        while (( $#dirstack )) && ! pushd -q $1 &>/dev/null; do popd -q $1; done
        (( $#dirstack ))
    } && {
        local f
        for f in chpwd "${chpwd_functions[@]}"; do
            [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
        done
    } && -z4h-redraw-prompt
}
zle -N -- -z4h-cd-rotate
function z4h-cd-back() { -z4h-cd-rotate +1 }
function z4h-cd-forward() { -z4h-cd-rotate -0 }
function z4h-cd-up() { cd .. && -z4h-redraw-prompt }
zle -N z4h-cd-back
zle -N z4h-cd-forward
zle -N z4h-cd-up

_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg

# }}}
# Keybindings & Alias {{{

bindkey '^Z' _zsh_cli_fg
bindkey '^[OA' z4h-up-local-history
bindkey '^[OB' z4h-down-local-history
bindkey -M emacs '^P' z4h-up-local-history
bindkey -M emacs '^N' z4h-down-local-history
bindkey '^[[1;5A' z4h-up-global-history
bindkey '^[[1;5B' z4h-down-global-history
bindkey '^[[1;3D' z4h-cd-back
bindkey '^[[1;3C' z4h-cd-forward
bindkey '^[[1;3A' z4h-cd-up
bindkey '^[[1;3B' fzf-cd-widget
# bindkey '^R' sane-fzf-history-widget

alias ipy='ipython3'
alias bpy='bpython'
alias rtr='ssh h.drone.riat.re'
alias emxc='emacsclient -nc'
alias emx='emacsclient -t'
alias factorz='python -m primefac'
alias bazel='bazelisk'
alias vol='python ~/lib/volatility/vol.py'

if (( $+commands[aws] )) && [[ -f "$HOME/.config/cloudflare-account-id" ]]; then
    alias r2="aws --profile=cf --endpoint-url https://$(cat $HOME/.config/cloudflare-account-id).r2.cloudflarestorage.com s3"
fi

if (( $+commands[git-branchless] )); then
    function git() {
        if [[ "$#" -eq 0 ]]; then
            command git "$@"
        else
            git-branchless wrap -- "$@"
        fi
    }
fi

function mkcd() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories mkcd

# fd-find in Debian is named /usr/bin/fdfind
if (( $+commands[fdfind] && ! ($+commands[fd]) )); then
    alias fd=fdfind
fi

# }}}
# Environment Managers {{{
# python-virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenv
[[ -f /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh ]] && source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh

# Go
export GOPATH="$HOME/.go"

# NodeJS, nvm is managed by zsh-nvm
export NVM_DIR="$HOME/.nvm"

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

if [[ ! -v _USE_ZOXIDE ]]; then
    _z_chpwd_handler() {
      (_z --add "${PWD:a}" &)
    }

    add-zsh-hook chpwd _z_chpwd_handler
fi

# Dedup $PATH again, it's way easier than fixing all the scripts (nix.sh etc)
typeset -aU path

# }}}

# zprof
# unsetopt xtrace
# exec 2>&3 3>&-
# vim: set foldmethod=marker :
