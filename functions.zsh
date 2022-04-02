# ==============================================================> Custom_Functions for Automation <====================================================================

# Ripgrep Pager support
rg() {
    # force ripgrep output to look like on a tty, even when sent to less(1)
    # env rg --heading --color always --line-number "$@"
    if [ -t 1 ]; then
        # command rg -p "$@" 2>/dev/null | less -RFX
        # command rg -p "$@" 2>/dev/null | less -RMFXK
        command rg -p "$@" 2>/dev/null | bat
    else
        command rg "$@" 2>/dev/null | bat
    fi
}

rga() {
    # force ripgrep output to look like on a tty, even when sent to less(1)
    # env rg --heading --color always --line-number "$@"
    if [ -t 1 ]; then
        command rga -p "$@" 2>/dev/null | bat
    else
        command rga "$@" 2>/dev/null | bat
    fi
}

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
 if [  "$#" -gt 0 ]; then
   echo "Need a string to search for!";
   return 1;
 fi
 rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
 # rg --files-with-matches --no-messages "$@" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$@' {}"
}

# like normal z when used with arguments but displays an fzf prompt when used without.
unalias j 2> /dev/null
j() {
   [ $# -gt 0 ] && _z "$*" && return
   cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# List topten commands used on shell
function commands() {
   awk '{a[$2]++}END{for(i in a){print a[i] " " i}}'
 }
alias top20="history | commands | sort -rn | head"

# fh - search in your command history and execute selected command
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Copy/Paste Function
if (( $+commands[xclip] && $#DISPLAY )); then
  alias x='xclip -selection clipboard -in'
  alias v='xclip -selection clipboard -out'
  alias c='xclip -selection clipboard -in -filter'
  function copy-buffer-to-clipboard() {
    print -rn -- "$PREBUFFER$BUFFER" | xclip -selection clipboard -in
  }
  zle -N copy-buffer-to-clipboard
  bindkey '^x' copy-buffer-to-clipboard
fi

# EXA file explore Setting
if [ -x "$(command -v exa)" ]; then
    alias ls="exa -l -F --icons --sort=date"
    alias la="exa --long --icons --all --group"
fi

# Brew/Man page setting
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  # gnubin; gnuman
  # for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
  # I actually like that man grep gives the BSD grep man page
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
fi

# Lazy youtube-dl script function

youtubedownload() {
 youtube-dl \
   -f '(bestvideo[ext=mp4]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' \
   --max-filesize 500m \
   --console-title \
   -o "~/Downloads/%(title)s.%(ext)s" \
   $*
}
youtubedownloadlist() {
 youtube-dl \
   -f '(bestvideo[ext=mp4]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' \
   --max-filesize 500m \
   --console-title \
   -o "~/Downloads/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" \
   $*
}
alias yd=youtubedownload
alias ydl=youtubedownloadlist
alias cdl='python -m youtube_dl -s'

# Populate hostname (SSH) completion. <<-------
# zstyle -e ':completion:*:hosts' hosts 'reply=(
#   ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
#   ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
#   ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
# )'

# # zshall(1) manpage documentation
zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall

}

# Move Up in directory
# up() {
#   local op=print
#   [[ -t 1 ]] && op=cd
#   case "$1" in
#     '') up 1;;
#     -*|+*) $op ~$1;;
#     <->) $op $(printf '../%.0s' {1..$1});;
#     *) local -a seg; seg=(${(s:/:)PWD%/*})
#        local n=${(j:/:)seg[1,(I)$1*]}
#        if [[ -n $n ]]; then
#          $op /$n
#        else
#          print -u2 up: could not find prefix $1 in $PWD
#          return 1
#        fi
#   esac
# }

# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}


# Movie Up in Directory path
# a() { alias $1=cd\ $PWD; }

#A small ZSH script to replace autojump (https://rrethy.github.io/book/jd.html)

### Function extract for common file formats ### (https://gitlab.com/dwt1/dotfiles)
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
IFS=$SAVEIFS
alias x='extract'

# rga file search
rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    xdg-open "$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX $@" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --bind=tab:down,btab:up \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
    )"
}

alias rgf='rga-fzf'
# =================================================================> BAT/fzf Pager/Fuzzy Configuration <==========================================================================

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
# =====> Interactive ripgrep integration.(Ctrl-F (Find in Files). https://github.com/junegunn/fzf/issues/1750)

RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case '
INITIAL_QUERY=''
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' $HOME"

ff() {
    fzf --bind "change:reload:$RG_PREFIX {q} $HOME || true" --ansi --phony --query "$INITIAL_QUERY" | cut -d ':' -f1
}

find-in-files() {
  LBUFFER="${LBUFFER}$(__fif)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N find-in-files
bindkey '^f' find-in-files

# =====================================================================> conda initialize <=============================================================================
# !! Contents within this block are managed by 'conda init' !!

# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
# else
#    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/opt/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/miniconda3/bin:$PATH"
#    fi
# fi
# unset __conda_setup
# ====================================================================> conda initialize <================================================================================
