#!/bin/sh
if !(type "vim" > /dev/null 2>&1); then
  sudo apt install vim
fi
if !(type "zsh" > /dev/null 2>&1); then
  sudo apt install zsh
fi
if !(type "git" > /dev/null 2>&1); then
  sudo apt install git
fi
if !(type "gawk" > /dev/null 2>&1); then
  sudo apt install gawk
fi
if !(type "fzf" > /dev/null 2>&1); then
  sudo apt install fzf
fi
# install zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

chsh -s $(which zsh)
