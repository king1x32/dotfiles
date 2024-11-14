# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            # Right-side prompt with exit codes and background processes
            #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    # alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
# alias ll='ls -l'
# alias la='ls -A'
# alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi




#====================================== User Custom ======================================#

#
# ~/.bashrc
#

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
# export LC_MESSAGES=en_US.UTF-8
# export LC_PAPER=en_US.UTF-8
# export LC_RESPONSE=en_US.UTF-8

# alias ls='ls -p --group-directories-first --color=auto'
# old_PS1='[\u@\h \W]\$ '
# PS1='\[\e[0;1;91m\][\[\e[0;1;94m\]\u\[\e[0m\]@\[\e[0;1;94m\]\H\[\e[m\] \[\e[0;3m\]\W\[\e[0;1;91m\]]\[\e[0m\]\$\[\e[m\] '

# custom aliases
alias l='eza -Ga --header --icons --hyperlink --time-style relative'
alias ll='eza -GlaoTL 2 --header --icons --hyperlink --time-style relative'
alias cdv="cd ~/.config/nvim/lua"
# this is to prevent accidental deletion of files with rm, use \rm to actually remove, TODO: start using trash-cli
alias rm='rm -rv'
alias yay='yay -a'
alias trm='trash-put'

alias g='git'
alias lg='gg'
# alias gg='lazygit'
alias fd='fdfind'

# editing configs
alias cfz="nvim ~/.zshrc && source ~/.zshrc"
alias cfs="nvim ~/.config/starship.toml"
alias cfv="nvim ~/.config/nvim/lua"
alias cfvv="nvim ~/.config/nvim/lua"
alias cfc="nvim ~/.config/nvim/lua/plugins/astrocore.lua"

# code editor aliases
alias v="nvim"
alias vi="nvim"
alias vv="nvim"
alias nv="nvim"
alias vim="nvim"

# xclip cmds are hard to remember!
# alias xcp="xclip -i -selection primary"
# alias xcc="xclip -i -selection clip"

# colorful man pages
# export LESS=-R
# export LESS_TERMCAP_mb=$'\e[1;31m'
# export LESS_TERMCAP_md=$'\e[1;31m'
# export LESS_TERMCAP_me=$'\e[0m'
# export LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$'\e[01;33m'
# export LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$'\e[1;4;32m'

function gg {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

function chst {
    [ -z $1 ] && echo "no args provided!" || (curl -s cheat.sh/$1 | bat --style=plain)
}

mkcd() {
    if [ "$#" -lt 1 ]; then
        echo "no arguments provided!"
        return
    elif [ "$#" -gt 1 ]; then
        echo "too many arguments! ignoring extra.."
    fi
    test -d "$1" || mkdir "$1" && cd "$1"
}

function gc() {
    if [[ !"$2" ]]; then
        git clone "$1"
        repo=$(echo "$1" | cut -d/ -f5)
        test_repo=${repo: -4}
        if [[ $test_repo == '.git' ]]; then
            repo=${repo: : -4}
        fi
        cd $repo
    else
        git clone "$1" "$2"
        cd "$2"
    fi
}

function gr() {
    git remote add "$1" "$2"
    git fetch --all
    git merge "$1"/main
}

gp() {
    git add -A
    git commit -m "update"
    git push
}

ga() {
    git add -A
    git commit --amend --no-edit
    git push -f
}

grs() {
    git reset --hard HEAD~$1
    git push -f
}

#nvm
# export PATH="/usr:$PATH"
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# devour aliases
#alias fehd="devour feh --scale-down"
#alias mpvd="devour mpv"
#alias zathurd="devour z"

#export VISUAL=ewrap
export EDITOR=nvim
# export TERMINAL='com.termux'
export SHELL=$(which bash)
# export TERMALT='termux'
export BROWSER=/home/king1x32/AppImage/zen/zen
# export PATH=$PATH:$(du "$HOME/.scripts" | cut -f1 | tr '\n' ':')

# nnn envars
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
NNN_PLUG_DEFAULT='r:rsyncp;f:fzcd;z:fzhist;g:gpge;o:fzopen'
NNN_PLUG_CMD='l:-!git log;x:!chmod +x "$nnn"*;n:!&nvim "$nnn"*'
NNN_PLUG="$NNN_PLUG_CMD;$NNN_PLUG_DEFAULT"
export NNN_PLUG
#alias nnn="nnn"
alias n="nnn -H -c -P r"
alias nn="sudo nnn -H -c -P r"
alias np="nnn -H -c -P x,r"
export NNN_BMS='h:~;d:~/Downloads;v:~/.config/nvim/lua;b:~/.local/bin;a:~/.local/share/applications;i:~/AppImage/icons'
export NNN_USE_EDITOR=1
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
#export NNN_INCLUDE_HIDDEN=1
#export NNN_SCRIPT="$HOME/.scripts/makewall"
#export NNN_OPTS="UcExr"
#export NNN_OPENER="nuke"
#export NNN_PIPE="/data/data/com.termux/"
# nnn theme
BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# aliases for blog sync [DEPRECATED]
# alias downblog="rsync -e 'ssh -i ~/Downloads/pc-arch-sync/aws_educate.pem' -avz ubuntu@host:/var/www/html/rustyelectron.live/public_html/ ~/myfiles/blog/"
# alias upblog="rsync -e 'ssh -i ~/Downloads/pc-arch-sync/aws_educate.pem' -avz ~/myfiles/blog/ ubuntu@host:/var/www/html/rustyelectron.live/public_html/"

# aliases for fzf
export FZF_DEFAULT_COMMAND="sudo rg --files --hidden"
#alias cpcmd="history | cut -c 8- | uniq | fzf | xclip -i -r -sel clipboard"
alias c='file=$(sudo rg --files --hidden | fzf | sed "s~/[^/]*$~/~");[[ "$file" == "" ]] || cd "$file"'
# alias cf='cd $(fd . -H -t d ~ | fzf --preview="ls {}" --bind="ctrl-space:toggle-preview" --preview-window=,30:hidden); [[ $(ls | wc -l) -le 60 && "$(pwd)" != $HOME ]] && (pwd; ls)'
alias cf='change_folder'
alias f='fzf'
alias vf='sudo rg --files --hidden | sudo fzf --preview="bat {}" --bind="ctrl-space:toggle-preview" --preview-window=:hidden'
alias rf='$(sudo rg --files --hidden | fzf)'

change_folder() {
    # if no argument is provided, search from ~ else use argument
    [[ -z $1 ]] && DIR=~ || DIR=$1
    # choose file using rg and fzf
    CHOSEN=$(fd --strip-cwd-prefix --full-path $DIR -H -t d | fzf --preview="exa -s type --icons {}" --bind="ctrl-space:toggle-preview" --preview-window=,30:hidden)

    # quit if no path is selected else cd into the path
    if [[ -z $CHOSEN ]]; then
        echo $CHOSEN
        return 1
    else
        cd "$CHOSEN"
    fi

    # show ls output if dir has less than 61 files
    [[ $(ls | wc -l) -le 60 ]] && (pwd; ls)
    return 0
}

# fzf superpower
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Use ,, as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER=',,'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
}

# open piew in current dir
# alias piewd='piew $(ls -1 | head -n1)'

# npm
#export npm_config_prefix="$HOME/.local"
#source "$HOME/.cargo/env"

# spring cleaning
# ---------------
# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

# ruby gems
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# wget
# export WGETRC="/usr/etc/wgetrc"
# alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'


# fnm
# export PATH="$HOME/.local/share/fnm:$PATH"
# eval "`fnm env`"
# eval "$(fnm env --use-on-cd)"

#neovim add mason path
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

#flyctl
# export FLYCTL_INSTALL="$HOME/.fly"
# export PATH="$FLYCTL_INSTALL/bin:$PATH"

#uncrustify
# alias uncrustify='find . \( -name "*.cpp" -o -name "*.c" -o -name "*.h" \) -exec uncrustify -c ~/.uncrustify/uncrustify.cfg --no-backup {} +'
# alias ua='find . \( -name "*.cpp" -o -name "*.c" -o -name "*.h" \) -exec uncrustify -c ~/.uncrustify/uncrustify.cfg --no-backup {} +'

#astyle
# alias astyle=astyle --style=google --suffix=none --options=$HOME/astyle_std
# alias as=astyle

export PATH="$HOME/.local/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
# export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# enable starship prompt
# eval "$(starship init bash)"
