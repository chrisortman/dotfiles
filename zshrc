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
plugins=(vi-mode git brew osx rails rvm history history-substring-search tmux docker colorize colored-man per-directory-history bundler)

# These paths first so that RVM can insert itself to beginning of path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"


# User configuration

DISABLE_AUTO_TITLE=true
alias tmux="TERM=screen-256color-bce tmux"
#alias emacs="$(brew --prefix emacs)/Emacs.app/Contents/MacOS/Emacs -nw"
foreground-vi() {
    fg %mvim
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
export FREETDS=$HOME/etc/freetds.conf
export TDSDUMP=""

# homebrew sometimes runs out of api requests so need to give it an api key
export HOMEBREW_GITHUB_API_TOKEN="32cad6323552a5e431cfeab772e750adfc2b1997"

# use the php53 I installed with homebrew instead of the system one
export PATH="$(brew --prefix homebrew/php/php53)/bin:$PATH"

# use homebrew's apache instead of system
export PATH="$(brew --prefix httpd24)/bin:$PATH"

#RVM complains in tmux if it isn't first
export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting

# pip should only run if there is a virtualenv currently activated
#export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
#export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# We source RVM before ZSH so we can put rvm info in our prompt
# http://unix.stackexchange.com/questions/134088/ruby-version-prompt-oh-my-zsh-not-working-outside-of-tmux
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
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

alias phpini='vim /usr/local/etc/php/5.3/php.ini'
alias viewdsn='vim -O config/database.yml ~/etc/odbc.ini ~/etc/freetds.conf'
alias ag='ag --color --ignore tags'
alias reseed-dev='SQLITE=true bundle exec rake {db:schema:load,seeds:all}'
alias reseed='SQLITE=true RAILS_ENV=test bundle exec rake {db:schema:load,seeds:all}'
alias sup='cd ~/code/uiris3/rails3 && SQLITE=true bundle exec rails server -u'
alias demo='cd ~/code/uiris3/rails3 && DEMO=true bundle exec rails server'
alias sab='cd ~/code/uiris3/sandbox && RAILS_ENV=test SQLITE=true script/server'
alias upload-gem='open http://vpr32.research.uiowa.edu:9290/upload'
alias vim='mvim -v'
#this stopped working when i moved some path logic before it?
bindkey '^Z' foreground-vi
bindkey '^X' foreground-server
