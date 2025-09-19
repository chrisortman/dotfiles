
if [[ $(cat /tmp/last.txt) == "orb" ]]; then
  echo "File contains orb"
	/Applications/OrbStack.app/Contents/MacOS/bin/orb '-m' 'ubuntu' '-w' "$(cat /tmp/lastdir.txt)"
else
	
	if [[ -f "/tmp/lastdir.txt" ]]; then
			WORKING_DIR=$(head -n1 /tmp/lastdir.txt | xargs)
			WORKING_DIR="${WORKING_DIR/#\~/$HOME}"  # Expand tilde
	else
			WORKING_DIR="$HOME"  # Default fallback
	fi

	# Validate and set working directory
	if [[ -n "$WORKING_DIR" && -d "$WORKING_DIR" ]]; then
			cd "$WORKING_DIR" || {
					echo "Warning: Could not change to $WORKING_DIR, using HOME" >&2
					cd "$HOME"
			}
	else
			cd "$HOME"
	fi

	# /usr/bin/login may have already sourced system files, but ensure user files are sourced
	# Note: with -l flag on zsh, these will be sourced again, which is usually safe
	if [[ -f "$HOME/.zprofile" ]]; then
		source "$HOME/.zprofile"
	fi

	# Set the current directory in PWD (important for some applications)
	export PWD="$(pwd)"

	# Start zsh as a login shell
	# The -l flag makes it a login shell, which will source additional config files
	exec /bin/zsh -l
  # /bin/zsh -l -c "cd /Users/cortman/code"
fi

