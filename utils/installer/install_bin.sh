#!/usr/bin/env bash
set -eo pipefail

INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

<<<<<<< HEAD
LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/lunarvim"}"
LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/lvim"}"
LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$XDG_CACHE_HOME/lvim"}"

LUNARVIM_BASE_DIR="${LUNARVIM_BASE_DIR:-"$LUNARVIM_RUNTIME_DIR/lvim"}"

function setup_shim() {
  local src="$LUNARVIM_BASE_DIR/utils/bin/lvim.template"
  local dst="$INSTALL_PREFIX/bin/lvim"
=======
NVIM_APPNAME="${NVIM_APPNAME:-lvim}"

LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/lunarvim"}"
LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/$NVIM_APPNAME"}"
LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$XDG_CACHE_HOME/$NVIM_APPNAME"}"
LUNARVIM_BASE_DIR="${LUNARVIM_BASE_DIR:-"$LUNARVIM_RUNTIME_DIR/$NVIM_APPNAME"}"

function setup_shim() {
  local src="$LUNARVIM_BASE_DIR/utils/bin/lvim.template"
  local dst="$INSTALL_PREFIX/bin/$NVIM_APPNAME"
>>>>>>> 14b0878 (upgrade new lunar vim)

  [ ! -d "$INSTALL_PREFIX/bin" ] && mkdir -p "$INSTALL_PREFIX/bin"

  # remove outdated installation so that `cp` doesn't complain
  rm -f "$dst"

  cp "$src" "$dst"

<<<<<<< HEAD
  sed -e s"#RUNTIME_DIR_VAR#\"${LUNARVIM_RUNTIME_DIR}\"#"g \
=======
  sed -e s"#NVIM_APPNAME_VAR#\"${NVIM_APPNAME}\"#"g \
    -e s"#RUNTIME_DIR_VAR#\"${LUNARVIM_RUNTIME_DIR}\"#"g \
>>>>>>> 14b0878 (upgrade new lunar vim)
    -e s"#CONFIG_DIR_VAR#\"${LUNARVIM_CONFIG_DIR}\"#"g \
    -e s"#CACHE_DIR_VAR#\"${LUNARVIM_CACHE_DIR}\"#"g \
    -e s"#BASE_DIR_VAR#\"${LUNARVIM_BASE_DIR}\"#"g "$src" \
    | tee "$dst" >/dev/null

  chmod u+x "$dst"
}

setup_shim "$@"

<<<<<<< HEAD
echo "You can start LunarVim by running: $INSTALL_PREFIX/bin/lvim"
=======
echo "You can start LunarVim by running: $INSTALL_PREFIX/bin/$NVIM_APPNAME"
>>>>>>> 14b0878 (upgrade new lunar vim)
