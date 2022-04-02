# Awesome_Aliases
# alias nav='lnav'

# alias ld='ls -tld **/*(m-2)'   # display file 2 day old. not compatible with exa
# alias td='ls -ltd -- *(-/)'    # not compatible with exa
# alias pdf='ls -tld **/*.pdf'   # not compatible with exa
# alias ppt='ls -tld **/*.pptx'  # not compatible with exa
# alias txt='ls -ltd **/*.txt'   # not compatible with exa
# alias ldr='ls -ltd *(/)'       # list only directory. not compatible with exa

alias ss="netstat"
alias cf='colorls -Stflr'
alias dc='colorls -Stdlr'
alias cls="colorls -trl --sort-dirs --report"
alias lc="colorls -Stlr"
alias lf='colorls -lA --Sftr'
alias colfs='colorls -Stflr'
alias colds='colorls -Stdlr'
alias col='colorls --group-directories-first --almost-all'
alias cols='colorls --group-directories-first --almost-all --long' # detailed list view
alias src="exec zsh"
alias ggp="ggrep"
alias bu='brew update && brew upgrade'
alias vim='nvim'
alias vi='nvim'
alias tl='tldr'
alias tr='tree'
alias dust='trash'
alias brewc='brew upgrade --cask'
alias su='sudo'
alias cda='conda deactivate'
alias ca='conda activate'
alias op='open .' #open current folder in the macOS Finder
alias lsc='ls *pdf | wc -l'  # list total count of pdf in current directory
alias lsl='ls *txt | wc-l'  # list total count of text in current directory
alias brewdoc='brew update && brew upgrade && brew cleanup; brew doctor'
alias zrc='subl ~/.zshrc'
alias cc='clear && clear'
alias cl='clear'

#Broot Alias
alias brt='br -dhp --sort-by-date'     # Broot alias
alias br='broot'
alias bs='br --sizes'

# SilverSearch-AG with patterns
# alias ag="ag $* --pager 'less -R'"
# alias ag="ag $* --pager 'bat' 2>/dev/null"
alias ag="ag --color-path "1;32" --color-match "30;41" --color-line-number "2;33" $* --pager 'bat' 2>/dev/null"

# neofetch
# alias neo='neofetch'

# start jupyter notebook
alias jnote='jupyter notebook'

# start jupyterlab
alias jlab='jupyter-lab'

#EXA file explorer
alias nfile='exa -l	 -snew'

#BAT A Cat Pager Setting
alias bgrep='batgrep'
alias bdiff='batdiff'
alias bman='batman'
alias bwatch='batwatch'
alias pbat='prettybat'


alias cat='bat --wrap=never --color=always --decorations=always'
alias bt='bat --style=plain --wrap=auto --color=always --decorations=always --terminal-width="$(($COLUMNS))"'

# alias cat='bat --color=always --decorations=always --terminal-width="$(($COLUMNS - 0))"'
# alias bt='bat --style=plain --wrap character --decorations=always --terminal-width="$(($COLUMNS - 0))"'

# alias bt='bat --style=plain --wrap character --color=always --decorations=always --terminal-width="$(($COLUMNS - 1))"'
# alias cat='bat --wrap=auto --color=always --decorations=always --terminal-width="$(($COLUMNS - 0))"'

#moar pager setting
# alias mo='moar -style fruity'
alias mo='moar -style solarized-dark256'

# alias ctm='moar -style fruity'
# alias mo='moar'
# alias mo='ct moar -wrap -style fruity'
# alias ctm='ct moar -style fruity'

# bfs instead of find
alias bf='bfs'

# Chromaterm Terminal Wide trigger
alias ctm='ct zsh --login'
alias py='python'

# asciinema rec (https://asciinema.org/)

# alias rec='asciinema rec'

# Aliases
alias untar='tar -zxvf' # Unpack .tar file
alias getpass='openssl rand -base64 20' # Generate password
alias sha='shasum -a 256' # Check shasum
# alias wget='wget -c' # Download and resume
# alias ping='ping -c 5' # Limit ping to 5'
# alias www='php -S localhost:8000' # Run local web server

# Changing "ls" to "exa"
alias lls='exa -al --color=always --group-directories-first' # my preferred listing
alias lla='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "
