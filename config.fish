# ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
# automatically by home-manager.

# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

if test -f ~/.localrc.fish
    source ~/.localrc.fish
end

fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/
fish_add_path -a /Applications/Postgres.app/Contents/Versions/latest/bin/
fish_add_path -a /opt/homebrew/bin/

status is-interactive; and begin
    # Aliases
    alias d docker
    alias dp podman
    alias e nvim
    alias egms 'e; git switch (git main-branch); and git sync'
    alias fd 'fd --hidden'
    alias freeze 'freeze -c full'
    alias g git
    alias ga 'git add'
    alias gaa 'git add -A'
    alias gb 'git branch -v'
    alias gc 'git commit -s'
    alias gca 'git commit -sa'
    alias gcai 'git --no-pager diff | mods '\''write a commit message for this patch. also write the long commit message. use semantic commits. break the lines at 80 chars'\'' >.git/gcai; git commit -a -F .git/gcai -e'
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
    alias gmt 'go mod tidy'
    alias gp 'git push origin HEAD'
    alias gpa 'git push origin --all'
    alias gpr 'git ppr'
    alias grm 'go run ./...'
    alias gs 'git status -sb'
    alias gw 'git switch'
    alias gwc 'git switch -c'
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
    alias la 'lsd -A'
    alias ll 'lsd -l'
    alias lla '/sd -lA'
    alias llt 'lsd -l --tree'
    alias ls lsd
    alias lt 'lsd --tree'
    alias sk 'kubectl -n kube-system'
    alias ta 'tmux new -A -s default'
    alias tf terraform
    alias v nvim
    alias vimdiff 'nvim -d'

    # Interactive shell initialisation
    fzf --fish | source

    # disable fish greeting
    set fish_greeting
    fish_config theme choose gruvbox
    set hydro_color_pwd brcyan
    set hydro_color_git brmagenta
    set hydro_color_error brred
    set hydro_color_prompt brgreen
    set hydro_color_duration bryellow
    set hydro_multiline true

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

    fish_add_path -p ~/.cargo/bin/

    fish_add_path -p ~/Developer/Go/bin

    zoxide init fish | source
end
