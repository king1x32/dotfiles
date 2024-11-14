#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias ls='ls -p --group-directories-first --color=auto'
old_PS1='[\u@\h \W]\$ '
PS1='\[\e[0;1;91m\][\[\e[0;1;94m\]\u\[\e[0m\]@\[\e[0;1;94m\]\H\[\e[m\] \[\e[0;3m\]\W\[\e[0;1;91m\]]\[\e[0m\]\$\[\e[m\] '

# custom aliases
alias l='ls -ah --color=auto'
alias ll='ls -ahl --color=auto'
alias cdv="cd ~/.config/nvim/lua"
# this is to prevent accidental deletion of files with rm, use \rm to actually remove, TODO: start using trash-cli
alias rm='rm -rvI'
alias yay='yay -a'
alias trm='trash-put'

alias g='git'
alias lg='lazygit'
alias gg='lazygit'

# editing configs
alias cfb="nvim ~/.bashrc && source ~/.bashrc"
alias cfs="nvim ~/.config/starship.toml"
alias cfv="nvim ~/.config/nvim/lua"
alias cfvv="nvim ~/.config/nvim/lua"
alias cfvn="nvim ~/.config/nvim/lua"
alias cfk="nvim ~/.config/nvim/lua/astronvim/mappings.lua"
alias cfo="nvim ~/.config/nvim/lua/astronvim/options.lua"

# code editor aliases
alias v="nvim"
alias vv="nvim"
alias nv="nvim"

# xclip cmds are hard to remember!
# alias xcp="xclip -i -selection primary"
# alias xcc="xclip -i -selection clip"

# colorful man pages
export LESS=-R
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;32m'

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
    git clone "$1"
}

function gr() {
    git remote add "$1" "$2"
    git fetch --all
    git merge "$1"/main
}

ga() {
    git add -A
    git commit -m "update"
    git push
}

grs() {
    git add -A
    git commit --amend --no-edit
    git push -f
}

grs() {
    git reset --hard HEAD~$1
    git push -f
}

#nvm
# export PATH="/data/data/com.termux/files/usr:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# devour aliases
#alias fehd="devour feh --scale-down"
#alias mpvd="devour mpv"
#alias zathurd="devour z"

#export VISUAL=ewrap
export EDITOR='nvim'
export TERMINAL='com.termux'
export SHELL=$(which bash)
export TERMALT='termux'
#export BROWSER=fennec
#export browser=fennec
# export PATH=$PATH:$(du "$HOME/.scripts" | cut -f1 | tr '\n' ':')

# nnn envars
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
NNN_PLUG_DEFAULT='r:rsyncp;f:fzcd;z:fzhist;g:gpge;o:fzopen'
NNN_PLUG_CMD='l:-!git log;x:!chmod +x "$nnn"*;n:!&nvim "$nnn"*'
NNN_PLUG="$NNN_PLUG_CMD;$NNN_PLUG_DEFAULT"
export NNN_PLUG
#alias nnn="nnn"
alias n="nnn -H -c -P r"
alias nn="nnn -H -c"
alias np="nnn -H -c -P x,r"
export NNN_BMS='h:~;d:~/downloads;v:~/.config/nvim/lua;b:/data/data/com.termux/files/usr/bin;1:~/storage/shared/Download/1DMP;n:~/storage/shared/Download/Nekogram;z:~/storage/shared/Download/Zalo;s:~/.scripts'
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
export FZF_DEFAULT_COMMAND="rg --files --hidden"
#alias cpcmd="history | cut -c 8- | uniq | fzf | xclip -i -r -sel clipboard"
alias c='file=$(rg --files --hidden | fzf | sed "s~/[^/]*$~/~");[[ "$file" == "" ]] || cd "$file"'
# alias cf='cd $(fd . -H -t d ~ | fzf --preview="ls {}" --bind="ctrl-space:toggle-preview" --preview-window=,30:hidden); [[ $(ls | wc -l) -le 60 && "$(pwd)" != $HOME ]] && (pwd; ls)'
alias cf='change_folder'
alias f='fzf'
alias vf='rg --files --hidden | fzf --preview="bat {}" --bind="ctrl-space:toggle-preview" --preview-window=:hidden'
alias rf='$(rg --files --hidden | fzf)'

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
source /data/data/com.termux/files/usr/share/fzf/key-bindings.bash
source /data/data/com.termux/files/usr/share/fzf/completion.bash

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
alias piewd='piew $(ls -1 | head -n1)'

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
export WGETRC="/data/data/com.termux/files/usr/etc/wgetrc"
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'


# fnm
# export PATH="/data/data/com.termux/files/home/.local/share/fnm:$PATH"
# eval "`fnm env`"
# eval "$(fnm env --use-on-cd)"

#neovim add mason path
export PATH="/data/data/com.termux/files/home/.local/share/nvim/mason/bin:$PATH"

#flyctl
# export FLYCTL_INSTALL="/data/data/com.termux/files/home/.fly"
# export PATH="$FLYCTL_INSTALL/bin:$PATH"

#uncrustify
# alias uncrustify='find . \( -name "*.cpp" -o -name "*.c" -o -name "*.h" \) -exec uncrustify -c ~/.uncrustify/uncrustify.cfg --no-backup {} +'
# alias ua='find . \( -name "*.cpp" -o -name "*.c" -o -name "*.h" \) -exec uncrustify -c ~/.uncrustify/uncrustify.cfg --no-backup {} +'

#astyle
# alias astyle=astyle --style=google --suffix=none --options=$HOME/astyle_std
# alias as=astyle

export PATH="/data/data/com.termux/files/usr/local/bin:$PATH"

# enable starship prompt
eval "$(starship init bash)"
