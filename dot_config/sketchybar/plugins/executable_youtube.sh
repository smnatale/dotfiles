#!/bin/bash

CHANNEL_URL="https://www.youtube.com/@sam_natale/about"
CACHE_DIR="${TMPDIR:-/tmp}/sketchybar-youtube"
CACHE_FILE="$CACHE_DIR/sam_natale-subscribers"

mkdir -p "$CACHE_DIR"

PAGE=$(curl -L --fail --silent --show-error --max-time 15 \
  -A "Mozilla/5.0" "$CHANNEL_URL" 2>/dev/null || true)

COUNT=$(printf '%s' "$PAGE" | perl -0ne '
  if (/"subscriberCountText":"([^"]+)"/s) {
    print $1;
  } elsif (/"subscriberCountText".{0,500}?"simpleText":"([^"]+)"/s) {
    print $1;
  }
' | sed -E 's/[[:space:]]+subscribers?$//')

case "$COUNT" in
  ''|*[!0-9.,KkMmBb]*) COUNT="" ;;
esac

format_count() {
  printf '%s\n' "$1" | perl -ne '
    chomp;
    if (/^([0-9]+(?:\.[0-9]+)?)([KkMmBb])?$/) {
      my ($number, $suffix) = ($1, $2 // "");
      my $multiplier = $suffix =~ /[Kk]/ ? 1000 :
        $suffix =~ /[Mm]/ ? 1000000 :
        $suffix =~ /[Bb]/ ? 1000000000 : 1;
      my $whole = int($number * $multiplier + 0.5);
      $whole =~ s/(?<=\d)(?=(\d{3})+$)/,/g;
      print $whole;
    }
  '
}

if [ -n "$COUNT" ]; then
  printf '%s\n' "$COUNT" > "$CACHE_FILE"
else
  COUNT=$(cat "$CACHE_FILE" 2>/dev/null || true)
fi

DISPLAY_COUNT=$(format_count "$COUNT")
sketchybar --set "$NAME" label="${DISPLAY_COUNT:----}"
