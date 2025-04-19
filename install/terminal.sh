sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget curl git unzip software-properties-common

# We need software properties common so we can add apt repositories as
# needed


for installer in ~/.dotfiles/install/terminal/*.sh; do source $installer; done

