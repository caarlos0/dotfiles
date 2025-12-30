set -x EDITOR nvim
set -x PROJECTS ~/Developer
set -x GOPATH ~/Developer/Go
fish_add_path -p ~/Developer/Go/bin
fish_add_path -p ~/.cargo/bin/
fish_add_path -p ~/.bin/
fish_add_path -a /opt/homebrew/bin/
fish_add_path -a /opt/homebrew/sbin
fish_add_path -a /Applications/Postgres.app/Contents/Versions/latest/bin/
fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/

status is-interactive; and begin
    # apps et al
    alias d docker
    alias e nvim
    alias v nvim
    alias vimdiff 'nvim -d'
    alias ta 'tmux new -A -s default'
    alias freeze 'freeze -c full'
    alias t task

    # go
    alias gmt 'go mod tidy'

    # git
    alias g git
    alias ga 'git add'
    alias gaa 'git add -A'
    alias gb 'git branch -v'
    alias gc 'git commit -s'
    alias gca 'git commit -sa'
    alias gcam 'git commit -sam'
    alias gcm 'git commit -sm'
    alias gco 'git checkout'
    alias gd 'git diff'
    alias gl 'git pull --prune'
    alias glg 'git log --graph --decorate --oneline --abbrev-commit'
    alias glga 'glg --all'
    alias glnext 'git log --oneline (git describe --tags --abbrev=0 @^)..@'
    alias gm 'git switch (git main-branch)'
    alias gms 'git switch (git main-branch); and git sync'
    alias gp 'git push origin HEAD'
    alias gpa 'git push origin --all'
    alias gpr 'git ppr'
    alias grm 'CGO_ENABLED=0 go run ./...'
    alias gs 'git status -sb'
    alias gw 'git switch'
    alias gwc 'git switch -c'

    # kubectl
    alias k kubectl
    alias kd 'kubectl describe'
    alias kdebug 'kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never'
    alias kdp 'kubectl describe po'
    alias kdrain 'kubectl drain --ignore-daemonsets --delete-local-data'
    alias ke 'kubectl edit'
    alias kex 'kubectl exec -it'
    alias kfails 'kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'
    alias kg 'kubectl get'
    alias kga 'kubectl get --all-namespaces'
    alias kgno 'kubectl get no --sort-by=.metadata.creationTimestamp'
    alias kgp 'kubectl get po'
    alias kimg 'kubectl get deployment --output=jsonpath='\''{.spec.template.spec.containers[*].image}'\'''
    alias kn kubens
    alias knrunning 'kubectl get pods --field-selector=status.phase!=Running'
    alias krm 'kubectl delete'
    alias kvs 'kubectl view-secret'
    alias kx kubectx
    alias sk 'kubectl -n kube-system'

    # files
    alias fd 'fd --hidden'
    alias la 'lsd -A'
    alias ll 'lsd -l'
    alias lla 'lsd -lA'
    alias llt 'lsd -l --tree'
    alias ls lsd
    alias lt 'lsd --tree'

    # nvim
    alias vim=nvim
    alias vi=nvim

    # disable fish greeting
    set fish_greeting
    fish_config theme choose oxocarbon-dark

    # Based on astronaut, but only shows user@host when connected via SSH,
    # uses '$' as prompt symbol instead of '❯', and supports transient prompts.
    #
    # See: https://github.com/fish-shell/fish-shell/blob/master/share/prompts/astronaut.fish
    function fish_prompt
        set -l last_status $status
        set -l normal (set_color normal)
        set -l status_color (set_color brgreen)
        set -l cwd_color (set_color $fish_color_cwd)
        set -l vcs_color (set_color brpurple)
        set -l user_info ""
        set -l prompt_status ""

        # Since we display the prompt on a new line allow the directory names to be longer.
        set -q fish_prompt_pwd_dir_length
        or set -lx fish_prompt_pwd_dir_length 0

        # Color the prompt differently when we're root
        set -l suffix '$'
        if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
                set cwd_color (set_color $fish_color_cwd_root)
            end
            set suffix '#'
        end

        # Color the prompt in red on error
        if test $last_status -ne 0
            set status_color (set_color $fish_color_error)
            set prompt_status $status_color "[" $last_status "]" $normal
        end

        if test -n "$SSH_CLIENT"
            set user_info (prompt_login) ' '
        end

        # if its final rendering, only show the suffix
        if contains -- --final-rendering $argv
            echo -n -s $status_color $suffix ' ' $normal
        else
            echo -s $user_info $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
            echo -n -s $status_color $suffix ' ' $normal
        end
    end

    # enable transient prompt to declutter the terminal
    set -g fish_transient_prompt 1

    # insert a new line after the output of a command:
    function postexec_test --on-event fish_postexec
        echo
    end

    # traps the shell quit and switch to the last session if it's the last pane
    # if last session is not available anymore, switch to default
    function __trap_exit_tmux
        test (tmux list-windows | count) = 1 || exit
        test (tmux list-panes | count) = 1 || exit
        tmux switch-client -l || tmux switch-client -t default
    end

    if set -q TMUX
        trap __trap_exit_tmux EXIT
    end

    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x HOMEBREW_NO_ENV_HINTS 1
    set -x FZF_DEFAULT_OPTS '--color bg:#161616,bg+:#262626,fg:#dde1e6,fg+:#f2f4f8,header:#ee5396,hl:#42be65,hl+:#42be65,info:#be95ff,marker:#78a9ff,pointer:#78a9ff,prompt:#be95ff,selected-bg:#393939,spinner:#78a9ff'

    zoxide init fish | source
    fzf --fish | source
    direnv hook fish | source
end

if test -f ~/.localrc.fish
    source ~/.localrc.fish
end
