function __wt_complete
    git rev-parse --git-dir >/dev/null 2>&1
    or return
    set -l remote_url (git remote get-url origin 2>/dev/null)
    set -l prefix
    if test -n "$remote_url"
        set prefix (basename $remote_url .git)-
    else
        set prefix (basename (git rev-parse --show-toplevel))-
    end
    git worktree list --porcelain | grep '^worktree ' | string replace 'worktree ' '' | while read -l wt
        string replace -- $prefix '' (basename $wt)
    end
end

complete --command wt --no-files
complete --command wt --long delete --short d --description "Remove a worktree"
complete --command wt --long list --short l --description "List worktrees"
complete --command wt --arguments '(__wt_complete)' --description "Worktree"
