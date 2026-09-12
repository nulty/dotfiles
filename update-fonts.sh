#!/usr/bin/env bash
set -euo pipefail

# Install/update the Nerd Font used by alacritty and nvim.
#
# nvim-web-devicons adopts new Nerd Font glyphs well before a font installed
# months ago has them, which shows up as blank boxes in nvim-tree. When that
# happens, check https://github.com/ryanoasis/nerd-fonts/releases, bump the
# version below, and run this. The terminal must be restarted afterwards.
#
#   ./update-fonts.sh            install the pinned version if not current
#   ./update-fonts.sh --check    report installed vs pinned, change nothing
#   ./update-fonts.sh --force    reinstall even if already current

nerd_font_version=3.4.0

release_asset=BitstreamVeraSansMono   # name in the nerd-fonts release
font_prefix=BitstromWeraNerdFontMono  # name of the patched files inside it
font_dir=${XDG_DATA_HOME:-$HOME/.local/share}/fonts
stamp=$font_dir/.nerd-font-version

mode=${1:-install}
installed=$(cat "$stamp" 2>/dev/null || echo "unknown")

# An install predating this script leaves no stamp, so fall back to reading the
# release string out of the font itself.
if [ "$installed" = "unknown" ] && [ -f "$font_dir/$font_prefix-Regular.ttf" ]; then
  installed=$(fc-query --format='%{fontversion}\n' "$font_dir/$font_prefix-Regular.ttf" >/dev/null 2>&1 &&
    strings "$font_dir/$font_prefix-Regular.ttf" 2>/dev/null |
    grep -o 'Nerd Fonts [0-9.]*' | head -1 | awk '{print $3}' || true)
  [ -n "$installed" ] || installed="unknown (no stamp)"
fi

case "$mode" in
  --check)
    echo "pinned:    $nerd_font_version"
    echo "installed: $installed"
    [ "$installed" = "$nerd_font_version" ] && echo "up to date" || echo "run ./update-fonts.sh to update"
    exit 0
    ;;
  --force) ;;
  install)
    if [ "$installed" = "$nerd_font_version" ]; then
      echo "Nerd Font $nerd_font_version already installed; nothing to do."
      exit 0
    fi
    ;;
  *)
    echo "usage: $0 [--check|--force]" >&2
    exit 64
    ;;
esac

echo "Installing Nerd Font $nerd_font_version (was: $installed)"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

url=https://github.com/ryanoasis/nerd-fonts/releases/download/v${nerd_font_version}/${release_asset}.zip
curl -fsSL -o "$tmp/font.zip" "$url"
unzip -oq "$tmp/font.zip" -d "$tmp" "$font_prefix-*.ttf"

mkdir -p "$font_dir"
cp "$tmp/$font_prefix-"*.ttf "$font_dir/"
echo "$nerd_font_version" > "$stamp"
fc-cache -f "$font_dir" >/dev/null

echo "Installed: $(ls "$tmp/$font_prefix-"*.ttf | wc -l) files into $font_dir"
echo "Restart the terminal to pick them up."
