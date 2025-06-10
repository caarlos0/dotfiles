function cdr -d "cd back to the root folder of the current repository"
    cd (git rev-parse --show-toplevel)
end
