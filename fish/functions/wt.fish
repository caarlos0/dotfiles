function __wt_complete
    git rev-parse --git-dir >/dev/null 2>&1
    or return
    git worktree list --porcelain | grep '^worktree ' | string replace 'worktree ' '' | while read -l wt
        basename $wt
    end
end

complete --command wt --no-files
complete --command wt --long delete --short d --description "Remove a worktree"
complete --command wt --long list --short l --description "List worktrees"
complete --command wt --arguments '(__wt_complete)' --description "Worktree"
