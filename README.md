# A dotfiles repo

This is intended to be a way to help get a brand new system up  and going for development
and also to have a version controlled place for dotfiles and configuration.

## Goals

1. Simple way to synchronize and version my development environment configuration across both mac and linux. Particularily vim/neovim, tmux, and shell config
2. Quick and simple way to get a new environment or machine up and running
3. Provide something that could be extracted or built upon to provide a _lazy_ setup tool for other dev

## Decisions

### Package Management

I want to keep updating simple, but I also want to be able to use new versions of _some_
tools because they are evolving.

For OS / system tools that I either don't care much about what version they are and am
confident I only need to have a single version of I try to install using the OS package
manager (apt)

For everything else I am letting mise do the work. In most cases the mise tools should come
from [aqua](https://aquaproj.github.io/) which seems to have some prett good security mitigations
in place to prevent supply chain attacks

I considered linuxbrew as an option that would work no matter what distro was being used but opted
not to because it would mean a 3rd option and was slow according to some comments in linux forums


### Neovim installation method

I've opted to install neovim via mise instead of via normal apt-get becuase some of the
popular plugins and tools use languages (python & lua) 

Since I'm managing these versions with mise it seems like there will be less duplication and
confusion to let neovim come in this way to so that dependencies all match up

## Credits

Inspired by and copied several ideas from https://omakub.org

