# A dotfiles repo

This is intended to be a way to help get a brand new system up  and going for development
and also to have a version controlled place for dotfiles and configuration.

## Package Management

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

## Credits

Inspired by and copied several ideas from https://omakub.org

