set -x EDITOR nvim
set -x PROJECTS ~/Developer
set -x GOPATH ~/Developer/Go
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x HOMEBREW_NO_ENV_HINTS 1
set -x FZF_DEFAULT_OPTS '--color bg:#101010,bg+:#161616,fg:#ffffff,fg+:#ffffff,header:#ffc799,hl:#99ffe4,hl+:#99ffe4,info:#a0a0a0,marker:#ffc799,pointer:#ffc799,prompt:#ffc799,selected-bg:#232323,spinner:#ffc799'

fish_add_path -p ~/Developer/Go/bin
fish_add_path -p ~/.cargo/bin/
fish_add_path -p ~/.local/bin/
fish_add_path -p ~/.bin/
fish_add_path -p ~/.orbstack/bin
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
    alias freeze 'freeze -c full'
    alias t task
    alias htop btop

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
    alias gpa 'git push origin --all'
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

    # enable transient prompt to declutter the terminal
    set -g fish_transient_prompt 1

    # insert a new line after the output of a command:
    function postexec_test --on-event fish_postexec
        echo
    end

    zoxide init fish | source
    fzf --fish | source
    direnv hook fish | source
end

if test -f ~/.localrc.fish
    source ~/.localrc.fish
end
