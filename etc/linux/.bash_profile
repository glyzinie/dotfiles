#!/usr/bin/env bash
export LANG=ja_JP.UTF-8

# XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# XDG User Directory
[[ -d $XDG_DATA_HOME/bash ]] || mkdir -p "$XDG_DATA_HOME/bash"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export HISTCONTROL=ignoreboth
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

exec zsh --login
