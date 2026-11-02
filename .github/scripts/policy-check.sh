#!/usr/bin/env bash
# Repository policy for this public repository (run by .github/workflows/security.yml).
#   1. Only approved files may be tracked.
#   2. Published text files may not contain internal paths, private project names, other e-mail addresses, scripts,
#      iframes, external stylesheets or trackers.
# Prints only file, line and rule name - never the matched text.
# usage: policy-check.sh <git-repository-directory>
set -euo pipefail
cd "${1:-.}"

APPROVED_FILES=(
  "index.html"
  ".claude/CLAUDE.md"
  ".gitleaks.toml"
  ".github/workflows/security.yml"
  ".github/scripts/policy-check.sh"
)
APPROVED_EMAIL="askagainlater.studio@gmail.com"
fail=0

# 1. file allowlist ------------------------------------------------------------------------------------------------
while IFS= read -r f; do
  ok=0
  for a in "${APPROVED_FILES[@]}"; do [[ "$f" == "$a" ]] && ok=1; done
  if [[ $ok -eq 0 ]]; then
    echo "::error file=${f}::Unapproved file (not on the allowlist in .github/scripts/policy-check.sh)"
    fail=1
  fi
done < <(git ls-files)

# 2. content policy for the published files --------------------------------------------------------------------------
check() {  # check <rule-name> <extended-regex> <file...>
  local name="$1" re="$2"; shift 2
  local f
  for f in "$@"; do
    [[ -f "$f" ]] || continue
    while IFS=: read -r line _; do
      [[ -n "$line" ]] || continue
      echo "::error file=${f},line=${line}::Content policy: ${name}"
      fail=1
    done < <(grep -nIiE -- "$re" "$f" | cut -d: -f1 | sed 's/$/:/' || true)
  done
}
TEXT=(index.html .claude/CLAUDE.md)
check "internal filesystem path"  '(/home/|/root/|/Users/|[A-Za-z]:\\\\|~/|\.config/)'            "${TEXT[@]}"
check "private project name"      '(animated[-_]shorts|drive_backup|manifest\.json)'              "${TEXT[@]}"
check "script, iframe or embed"   '<(script|iframe|object|embed)\b'                               index.html
check "external stylesheet/font"  '(<link[^>]+rel=["'"'"']?stylesheet|@import|url\()'            index.html
check "tracker or analytics tag"  '(gtag\(|googletagmanager|google-analytics|fbq\(|connect\.facebook\.net|plausible|matomo|hotjar)' index.html

# e-mail addresses: only the approved public contact
for f in "${TEXT[@]}"; do
  [[ -f "$f" ]] || continue
  while IFS=: read -r line addr; do
    if [[ "${addr,,}" != "${APPROVED_EMAIL}" ]]; then
      echo "::error file=${f},line=${line}::Content policy: e-mail address other than the approved public contact"
      fail=1
    fi
  done < <(grep -noE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$f" || true)
done

if [[ $fail -ne 0 ]]; then
  echo "Policy check FAILED"
  exit 1
fi
echo "Policy check passed: $(git ls-files | wc -l) approved files, content policy clean"
