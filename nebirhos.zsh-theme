# Based on robbyrussell's theme, with host and rvm indicators. Example:
# @host ➜ currentdir rvm:(rubyversion@gemset) git:(branchname)

aws_prompt_info() {
  local IDENTITY_FILE=~/.aws-login/identity.txt
  local PROF=""

  if [[ -f "$IDENTITY_FILE" ]] then

    PROF=$( cat "$IDENTITY_FILE" 2>/dev/null)
    [[ -n "$PROF" ]] && echo "[$PROF]"
  fi
}
# Get the current ruby version in use with RVM:
RUBY_PROMPT_="%{$fg_bold[green]%}\$(chruby_prompt_info) "
# Get the host name (first 4 chars)
HOST_PROMPT_='%{$fg_bold[red]%}$(aws_prompt_info) %{$fg_bold[cyan]%}%d '
GIT_PROMPT="%{$fg_bold[blue]%}\$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}"
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$GIT_PROMPT
➜  "

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
