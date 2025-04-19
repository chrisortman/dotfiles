# Display system information in the terminal
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update -y
sudo apt install -y fastfetch

# Only attempt to set configuration if fastfetch is not already set
# I'm not sure if or that I want to use any conig management here
# like omakub does
# I think I want to manage all this with stow
