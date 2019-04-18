#!/bin/sh
if !(type "vim" > /dev/null 2>&1); then
  sudo apt install vim
fi
if !(type "zsh" > /dev/null 2>&1); then
  sudo apt install zsh
fi
if !(type "anyenv" > /dev/null 2>&1); then
  git clone https://github.com/anyenv/anyenv ~/.anyenv
  ~/.anyenv/bin/anyenv init
fi
if !(type "zgen" > /dev/null 2>&1); then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi
chsh -s $(which zsh)
