#!/usr/bin/env bash

mv "$HOME/.bashrc" "$HOME/.bashrc_bkp"
mv "$HOME/.vimrc" "$HOME/.vimrc_bkp"
mv "$HOME/.config" "$HOME/.config_bkp"
mv "$HOME/.xmonad" "$HOME/.xmonad_bkp"
mv "$HOME/.tmux.conf" "$HOME/.tmux.conf_bkp"

ln -s "$PWD/.bashrc" "$HOME/.bashrc"
ln -s "$PWD/.vimrc" "$HOME/.vimrc"
ln -s "$PWD/.config" "$HOME/.config"
ln -s "$PWD/.xmonad" "$HOME/.xmonad"
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
