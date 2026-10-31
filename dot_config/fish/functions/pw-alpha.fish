function pw-alpha -d "generates a simple alphanumeric password"
    set -l length 43
    if test (count $argv) -gt 0
        set length $argv[1]
    end

    # 1,6× so viele Bytes wie nötig → mehr als genug Entropie für die Filterung
    set -l bytes (math "ceil($length * 5 / 4) + 8")

    openssl rand -base64 $bytes \
        | tr -cd '[:alnum:]' \
        | head -c $length
    echo
end
