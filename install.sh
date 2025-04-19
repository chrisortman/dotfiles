set -e

# Omakub has checked out code to some place and is running it from
# there and uses full paths.
# Using relative paths didn't work here, so I'm just hard coding it

source ~/.dotfiles/install/check-version.sh

echo "Installing terminal tools"
source ~/.dotfiles/install/terminal.sh
