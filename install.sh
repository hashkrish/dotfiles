#!/usr/bin/env bash

mv "$HOME/.bashrc" "$HOME/.bashrc_bkp"
mv "$HOME/.vimrc" "$HOME/.vimrc_bkp"
mv "$HOME/.config" "$HOME/.config_bkp"
mv "$HOME/.xmonad" "$HOME/.xmonad_bkp"
mv "$HOME/.tmux.conf" "$HOME/.tmux.conf_bkp"

ln -s .bashrc "$HOME/.bashrc"
ln -s .vimrc "$HOME/.vimrc"
ln -s .config "$HOME/.config"
ln -s .xmonad "$HOME/.xmonad"
ln -s .tmux.conf "$HOME/.tmux.conf"
