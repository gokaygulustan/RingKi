#!/usr/bin/env bash
set -euo pipefail

exe="${1:-build/RingKi.exe}"
allowed=" kernel32.dll user32.dll gdi32.dll comctl32.dll comdlg32.dll winmm.dll shell32.dll msvcrt.dll advapi32.dll ole32.dll uuid.dll "
imports="$(i686-w64-mingw32-objdump -p "$exe" | awk '/DLL Name:/ { print tolower($3) }' | sort -u)"
bad=0
while IFS= read -r dll; do
  [[ -z "$dll" ]] && continue
  if [[ "$allowed" != *" $dll "* ]]; then
    printf 'Unexpected DLL import: %s\n' "$dll" >&2
    bad=1
  fi
done <<< "$imports"
if (( bad )); then exit 1; fi
printf 'Allowed Windows system DLL imports: %s\n' "$(tr '\n' ' ' <<< "$imports")"
