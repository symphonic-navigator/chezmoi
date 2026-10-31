if status is-interactive
    set -g fish_greeting
    set -g fish_key_bindings fish_vi_key_bindings

    set -gx LANG en_US.UTF-8

    if command -q starship
        starship init fish | source
    end

    if command -q zoxide
        zoxide init fish | source
    end

    if command -q direnv
        direnv hook fish | source
    end

    # kitty: ssh über das kitten, damit terminfo & Co. mitkommen
    if set -q KITTY_WINDOW_ID
        function ssh --wraps ssh
            kitten ssh $argv
        end
    end

    alias pamcan pacman

    # Maschinenlokale Overrides, nicht in chezmoi
    if test -f ~/.local-env.fish
        source ~/.local-env.fish
    end
end
