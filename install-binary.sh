#!/bin/sh

set -e

dir=$(dirname "$0")
current_version=$(sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' "$dir/plugin.yaml")
HELM_DIFF_VERSION=${HELM_DIFF_VERSION:-$current_version}

dir=${HELM_PLUGIN_DIR:-"$(helm home)/plugins/helm-diff"}
os=$(uname -s | tr '[:upper:]' '[:lower:]')
test "$os" = "darwin" && os=macos
release_file="helm-diff-${os}.tgz"
install_file="$dir/diff"
url="https://github.com/gechr/helm-diff/releases/download/v${HELM_DIFF_VERSION}/${release_file}"

mkdir -p "$dir"
tmpdir=$(mktemp -d)
tmpfile="$tmpdir/$release_file"

if command -v wget >/dev/null; then
  command wget -qO "$tmpfile" "$url"
elif command -v curl; then
  command curl -sSL -o "$tmpfile" "$url"
fi

command tar -zxf "$tmpfile" -C "$tmpdir"
command mv -f "$tmpdir/diff/diff" "$install_file"
chmod +x "$install_file"
command rm -rf -- "$tmpdir"
