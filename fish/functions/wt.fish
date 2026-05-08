function __wt_complete
    git rev-parse --git-dir >/dev/null 2>&1
    or return
    set -l main_wt (git worktree list --porcelain | head -1 | string replace 'worktree ' '')
    set -l wt_path ""
    for line in (git worktree list --porcelain)
        if string match -q 'worktree *' $line
            set wt_path (string replace 'worktree ' '' $line)
        else if string match -q 'branch *' $line
            if test "$wt_path" != "$main_wt"
                string replace 'branch refs/heads/' '' $line
            end
            set wt_path ""
        end
    end
end

complete --command wt --no-files
complete --command wt --long delete --short d --description "Remove a worktree"
complete --command wt --long list --short l --description "List worktrees"
complete --command wt --long cleanup --short c --description "Remove all merged worktrees"
complete --command wt --arguments '(__wt_complete)' --description "Worktree"
