function pw-hex -d "generates a hexadecimal password"
    set -l length 32
    if test (count $argv) -gt 0
        set length $argv[1]
    end

    openssl rand -hex (math "ceil($length / 2)") | head -c $length
    echo
end
