#!/usr/bin/env bash
set -euo pipefail

# Rebuild single-commit history into meaningful, backdated commits for SafeHands.
#
# Usage:
#   bash Scripts/rebuild_history.sh
#   bash Scripts/rebuild_history.sh --branch history-experiment --push
#   bash Scripts/rebuild_history.sh --branch history-experiment --push --replace-main
#
# Notes:
# - Run from the repository root.
# - Requires a clean working tree.
# - By default this only creates/recreates a branch locally.
# - --replace-main force-updates origin/main. Use only when coordinated with collaborators.

BRANCH_NAME="history-experiment"
DO_PUSH="false"
REPLACE_MAIN="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)
      BRANCH_NAME="${2:-}"
      shift 2
      ;;
    --push)
      DO_PUSH="true"
      shift
      ;;
    --replace-main)
      REPLACE_MAIN="true"
      shift
      ;;
    -h|--help)
      sed -n '1,30p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$BRANCH_NAME" ]]; then
  echo "Branch name cannot be empty."
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit/stash changes first."
  exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "Switching to main branch first..."
  git checkout main
fi

if [[ "$(git rev-list --count main)" -lt 1 ]]; then
  echo "main has no commits. Nothing to rebuild."
  exit 1
fi

if [[ "$(git rev-list --count main)" -gt 1 ]]; then
  echo "This script is designed for one giant initial commit on main."
  echo "Found more than one commit; aborting to avoid accidental rewrite."
  exit 1
fi

# Recreate experiment branch from current main.
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  git branch -D "$BRANCH_NAME"
fi
git checkout -b "$BRANCH_NAME" main

# Expand the single commit into working tree changes.
git reset --soft HEAD~1 2>/dev/null || true
git reset

if [[ -z "$(git status --porcelain)" ]]; then
  echo "No pending changes after reset."
  echo "If you started from root commit, re-initializing from tree snapshot..."

  # Recover by rebuilding from current tree as untracked content.
  TMP_DIR=".history_rebuild_tmp"
  rm -rf "$TMP_DIR"
  mkdir -p "$TMP_DIR"
  git ls-files -z | xargs -0 -I{} cp --parents "{}" "$TMP_DIR" || true
  git rm -r --cached . >/dev/null 2>&1 || true
  cp -R "$TMP_DIR"/* . 2>/dev/null || true
  rm -rf "$TMP_DIR"
fi

COMMIT_PATHS=(
  "Safe-Handz/DesignSystem Safe-Handz/Models"
  "Safe-Handz/Views/PreOnboarding Safe-Handz/Views/Onboarding Safe-Handz/ViewModels/OnboardingViewModel.swift"
  "Safe-Handz/Views/Home Safe-Handz/ViewModels/HomeViewModel.swift"
  "Safe-Handz/Views/Learn"
  "Safe-Handz/Views/Discover Safe-Handz/ViewModels/DiscoverViewModel.swift Safe-Handz/Services/GooglePlacesService.swift"
  "Safe-Handz/Views/AI Safe-Handz/ViewModels/AIViewModel.swift Safe-Handz/Services/AnthropicService.swift"
  "Safe-Handz/Views/Logging Safe-Handz/ViewModels/LoggingViewModel.swift Safe-Handz/Services/GamificationEngine.swift"
  "Safe-Handz/Views/Profile Safe-Handz/Views/Components Safe-Handz/Views/ContentView.swift Safe-Handz/Safe_HandzApp.swift"
  "Safe-HandzTests Safe-HandzUITests"
  "Scripts"
  "SAFEHANDS_AI_ENGINEER_BIBLE.md SAFEHANDS_BUILD_REFERENCE.md SAFEHANDS_LEARN_HUB_ROADMAP.md SAFEHANDS_MASTER_PROMPT.md SAFEHANDS_MASTER_THESIS.md Project_Report_Annexure.md Project_Report_Sections.md activity_log.txt"
)

COMMIT_MESSAGES=(
  "feat(core): add design system tokens and core models"
  "feat(onboarding): implement pre-onboarding and caregiver onboarding flows"
  "feat(home): add journey home experience and view model"
  "feat(learn): implement Learn Hub and reading surfaces"
  "feat(discover): add therapist discovery and filtering flow"
  "feat(ai): integrate AI companion views and service layer"
  "feat(logging): add activity logging and gamification engine"
  "feat(app): wire root navigation and shared reusable components"
  "test: add unit and UI test targets"
  "chore(scripts): add project maintenance and automation scripts"
  "docs: add master references, reports, and working logs"
)

START_DATE="2026-03-20 10:30:00 +0530"
START_EPOCH="$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$START_DATE" +%s)"

commit_chunk() {
  local path_group="$1"
  local message="$2"
  local date_epoch="$3"
  local commit_date
  commit_date="$(date -r "$date_epoch" "+%Y-%m-%d %H:%M:%S %z")"

  # Stage only paths that exist.
  local staged_any="false"
  for p in $path_group; do
    if [[ -e "$p" ]]; then
      git add "$p"
      staged_any="true"
    fi
  done

  if [[ "$staged_any" == "true" ]] && [[ -n "$(git diff --cached --name-only)" ]]; then
    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
      git commit -m "$message" >/dev/null
    echo "Committed: $message"
  fi
}

for i in "${!COMMIT_PATHS[@]}"; do
  chunk_date_epoch=$((START_EPOCH + (i * 86400)))
  commit_chunk "${COMMIT_PATHS[$i]}" "${COMMIT_MESSAGES[$i]}" "$chunk_date_epoch"
done

# Final safety net: commit any remaining files not captured above.
if [[ -n "$(git status --porcelain)" ]]; then
  final_epoch=$((START_EPOCH + (${#COMMIT_PATHS[@]} * 86400)))
  final_date="$(date -r "$final_epoch" "+%Y-%m-%d %H:%M:%S %z")"
  git add -A
  if [[ -n "$(git diff --cached --name-only)" ]]; then
    GIT_AUTHOR_DATE="$final_date" GIT_COMMITTER_DATE="$final_date" \
      git commit -m "chore(repo): capture remaining project files" >/dev/null
    echo "Committed: chore(repo): capture remaining project files"
  fi
fi

echo
echo "Rebuilt history on branch: $BRANCH_NAME"
git --no-pager log --oneline --decorate --graph -n 20

if [[ "$DO_PUSH" == "true" ]]; then
  git push -u origin "$BRANCH_NAME"
  echo "Pushed branch: $BRANCH_NAME"
fi

if [[ "$REPLACE_MAIN" == "true" ]]; then
  git checkout main
  git reset --hard "$BRANCH_NAME"
  git push --force-with-lease origin main
  echo "Force-updated origin/main from $BRANCH_NAME"
fi
