function fish_prompt

    # define git functions if not already defined
    if not set -q -g __fish_git_functions_defined
        set -g __fish_git_functions_defined
        function _git_branch_name
            echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
        end
        function _is_git_dirty
            echo (git status -s --ignore-submodules=dirty ^/dev/null)
        end
    end

    # define hostname if not already defined
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    # shortcuts for colors
    set -l cyan (set_color  cyan)
    set -l yellow (set_color -u D0BB2C)
    set -l magenta (set_color  magenta)
    set -l green (set_color 36BC26)
    set -l red (set_color C12326)
    set -l blue (set_color 	0082C6)
    set -l normal (set_color normal)

    # cool emoji skull
    #set -l skull $normal"😬 "
    set -l skull $normal'$ '

    # user at host
    set -l user_host $normal"$USER@$__fish_prompt_hostname"

    # set path
    set -l cwd $yellow(prompt_pwd)$normal

    # if git branch
    if [ (_git_branch_name) ]
        set git_info $blue"("(_git_branch_name)")"

        # if dirty
        if [ (_is_git_dirty) ]
            set -l dirty "$red ✗"
            set git_info "$git_info$dirty "
        else
            set -l dirty "$green ✓"
            set git_info "$git_info$dirty "
        end
    end

    echo -n -s "$user_host $cwd $git_info$skull"
end
