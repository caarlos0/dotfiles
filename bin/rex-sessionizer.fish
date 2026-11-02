set -l client "$argv[1]"
set -l results (__project_list); or exit 1
test (count $results) -gt 0; or exit 0
set -l selected (printf '%s\n' $results | cut -f2 | fzf --no-sort --prompt="  ")
set -l picker_status $pipestatus[-1]
if test $picker_status -ne 0
    test $picker_status -eq 1 -o $picker_status -eq 130; and exit 0
    exit $picker_status
end
test -n "$selected"; or exit 0

set -l sessions (rex ls --json); or exit 1
set -l matches (string join \n -- $sessions | jq -r --arg label "$selected" '(.sessions // [])[] | select(.label == $label) | .session_id'); or exit 1
if test (count $matches) -gt 1
    echo "Multiple Rex sessions named $selected; rename the duplicates." >&2
    exit 1
end

if test (count $matches) -eq 1
    set session "$matches[1]"
else
    set -l created (rex new "$selected" -c "$PROJECTS/$selected" --json); or exit 1
    set session (string join \n -- $created | jq -er '.session_id'); or exit 1
end

rex -C "$client" do session.select session_id="$session"; or exit 1
zoxide add "$PROJECTS/$selected"
