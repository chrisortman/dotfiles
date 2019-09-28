if [[ -v ZSH_PROF ]]; then
  zmodload zsh/zprof
fi

if [ -e ~/Dropbox/.secrets ]; then
  source ~/Dropbox/.secrets
fi

if [ -e /keybase/private/chriso/.secrets ]; then
  source /keybase/private/chriso/.secrets
fi

if [ -e ~/.config/.local_secrets ]; then
  source ~/.config/.local_secrets
fi

_has(){
    command type "$1" > /dev/null 2>&1
}

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="nebirhos"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=2

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


export NVM_LAZY_LOAD=true
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode git brew osx rails chruby zsh-nvm history history-substring-search tmux docker colorize colored-man  bundler z)

#####
# I couldn't come up with a quick and easy way to not have the chruby plugin load the
# auto change ruby stuff, so I hacked my auto.sh script that homebrew installs
# to not sitck the preexec function in
# ####

# User configuration

DISABLE_AUTO_TITLE=true
alias tmux="TERM=screen-256color-bce tmux"
#alias emacs="$(brew --prefix emacs)/Emacs.app/Contents/MacOS/Emacs -nw"
foreground-vi() {
    fg %/usr/local/bin/vim
}


zle -N foreground-vi

foreground-server() {
    fg %server
}

export EDITOR="vim"


# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# setup postresql command line tools
export PATH="/Users/cortman/bin:/Applications/Postgres.app/Contents/Versions/latest/bin::/Users/cortman/.cargo/bin:$PATH/usr/local/sbin:/Users/cortman/gocode/bin:/Users/cortman/Library/Python/3.7/bin"

source $ZSH/oh-my-zsh.sh

function backup() {
  cp $1 $1~
}

function restore() {
 cp $1~ $1
}

function edit-last () {
  local cmd
  setopt local_options extended_glob
  for cmd in $history; do
    case $cmd in
      ((ls|(cvs|git|hg|svn) status)(| *)) :;;
      ("ag "*) vim -q<(eval "$cmd --vimgrep"); return;;
      (edit-last) :;;
      (*) echo >&2 "The previous ag command is too old."; return 125;;
    esac
  done
}

reload-dir () {
  cd ../
  cd $OLDPWD
  zle .accept-line
}

zle -N reload-dir

spring-web-app-generate () {
  mvn archetype:generate  \
  -DarchetypeGroupId=edu.uiowa.icts.archetype  \
  -DarchetypeArtifactId=spring-4-web-application  \
  -DarchetypeVersion=1.0.2-SNAPSHOT \
  -DgroupId=edu.uiowa.icts  \
  -Dversion=0.0.1-SNAPSHOT \
  -DartifactId=$1
}

github-ignore () {
  curl https://raw.githubusercontent.com/github/gitignore/master/$1.gitignore
}

if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf + ag configuration
if _has fzf && _has ag; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi

alias docker-remove-stopped-containers='docker rm $(docker ps -a -q)'
alias docker-remove-dangling-images='docker rmi $(docker images -q -f dangling=true)'

# Automatically report time 
# for any commands that take longer than 5 seconds to run
export REPORTTIME=60


alias ag='ag --color --ignore tags'
alias vim='/usr/local/bin/vim'
alias vi='/usr/local/bin/vim'
alias rcd='cd .. && cd $OLDPWD'
alias ff='open -a firefox http://localhost:3000'
alias gg="open -a 'Google Chrome' http://localhost:3000"
alias retag='ctags -R -f .git/tags'
alias mysql-start='launchctl load -F /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias mysql-stop='launchctl unload -F /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias ping='prettyping --nolegend'
alias top="sudo htop"
alias every-third="awk 'NR == 1 || NR % 3 == 0'"
alias profile='/usr/local/bin/gtime -f "mem=%K RSS=%M elapsed=%E cpu.sys=%S .user=%U"'

#this stopped working when i moved some path logic before it?
bindkey '^Z' foreground-vi
bindkey '^X' foreground-server
bindkey '^r' reload-dir

# Need to define this in order to install 
# go happyfinder binary
export GOPATH=~/gocode

chruby ruby-2.5.5
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

export JETTY_MAVEN_OPTS="-Xms2000m -Xmx2000m -XX:MaxPermSize=2000m"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f /Users/cortman/.travis/travis.sh ] && source /Users/cortman/.travis/travis.sh

source ~/bin/tmuxinator.zsh

precmd() {
  # sets the tab title to current dir
  CURRENT=$(print -P %3~)
  echo -ne "\e]1;~/${CURRENT##*/}\a"
}

function iterm2_print_user_vars() {
  iterm2_set_user_var currTime $(date +%T)
}

# No analytics please
export HOMEBREW_NO_ANALYTICS=1

# source $HOME/.asdf/asdf.sh
# source $HOME/.asdf/completions/asdf.bash

 [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

unalias rg
