if [ -e ~/Dropbox/.secrets ]; then
  source ~/Dropbox/.secrets
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
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
# DISABLE_AUTO_TITLE="true"

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


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode git brew osx rails chruby history history-substring-search tmux docker colorize colored-man  bundler z)
# These paths first so that RVM can insert itself to beginning of path
# export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

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

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



# ODBC Environment variables
export ODBCINI=$HOME/etc/odbc.ini
export ODBCSYSINI=$HOME/etc
export FREETDSCONF=$HOME/etc/freetds.conf

# setup postresql command line tools
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin


# pip should only run if there is a virtualenv currently activated
#export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
#export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

export PATH="/Users/cortman/bin:$PATH"

source $ZSH/oh-my-zsh.sh

function bzmerge3() {
  kdiff3 $1.BASE $1.THIS $1.OTHER -o $1
}

function bzdiff() {
  bzr diff $* | view -
}

function backup() {
  cp $1 $1~
}

function restore() {
 cp $1~ $1
}

function verify-with-docker() {
  cd uiris3/source
  git remote update upstream
  git remote update local
  git remote update origin
  git reset --hard $1
  cd ../..
  ./build.sh && ./cucumber.sh;say done
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

function uiris-env () {
  echo "DB: $DB"
  echo "DSN: $DSN"
  echo "DBD: $DBD"
  echo "HOST: $HOST"
  echo "SQLITE: $SQLITE"
  echo "DEMO: $DEMO"
  echo "RAILS_ENV: $RAILS_ENV"
  echo "SKIP_LINT: $SKIP_LINT"
  echo "DEV_FOX: $DEV_FOX"
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
alias docker-remove-stopped-containers='docker rm $(docker ps -a -q)'
alias docker-remove-dangling-images='docker rmi $(docker images -q -f dangling=true)'
  
# Automatically report time 
# for any commands that take longer than 5 seconds to run
export REPORTTIME=5


alias ag='ag --color --ignore tags'
alias vim='/usr/local/bin/vim'
alias rcd='cd .. && cd $OLDPWD'
alias ff='open -a firefox http://localhost:3000'
alias gg="open -a 'Google Chrome' http://localhost:3000"
alias retag='ctags -R -f .git/tags'
alias mysql-start='launchctl load -F /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias mysql-stop='launchctl unload -F /usr/local/opt/mysql/homebrew.mxcl.mysql.plist'
alias hfg='hf -git'

#this stopped working when i moved some path logic before it?
bindkey '^Z' foreground-vi
bindkey '^X' foreground-server
bindkey '^r' reload-dir
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:~/code/simple-revision-control

# Need to define this in order to install 
# go happyfinder binary
export GOPATH=~/gocode
export PATH=$PATH:~/gocode/bin

chruby ruby-2.3.1
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

export JETTY_MAVEN_OPTS="-Xms2000m -Xmx2000m -XX:MaxPermSize=2000m"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/node@6/bin:$PATH"

# added by travis gem
[ -f /Users/cortman/.travis/travis.sh ] && source /Users/cortman/.travis/travis.sh
source ~/bin/tmuxinator.zsh
