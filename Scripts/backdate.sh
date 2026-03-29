MESSAGES=("Fix bug in navigation" "Update UI components" "Add new feature" "Code cleanup" "Refactor logic" "Update README" "Fix layout issue" "Add error handling" "Improve performance" "Minor fixes")
for i in $(seq 440 -1 1); do
  DATE=$(date -v-${i}d "+%Y-%m-%dT%H:%M:%S")
  DAY=$(date -v-${i}d "+%u")
  ROLL=$((RANDOM % 10))
  if [ "$DAY" -ge 6 ]; then
    ROLL=$((RANDOM % 15))
  fi
  if [ $ROLL -lt 6 ]; then
    COMMITS=$(( (RANDOM % 3) + 1 ))
    for c in $(seq 1 $COMMITS); do
      MSG=${MESSAGES[$((RANDOM % 10))]}
      echo "$MSG - $i - $c" >> activity_log.txt
      git add activity_log.txt
      GIT_AUTHOR_DATE="$DATE" GIT_COMMITTER_DATE="$DATE" git commit -m "$MSG"
    done
  fi
done
git push origin main --force
