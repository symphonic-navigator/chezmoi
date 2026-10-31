function claude --wraps=claude --description 'claude with the gh token for the GitHub MCP server'
    # Das GitHub-Plugin erwartet GITHUB_PERSONAL_ACCESS_TOKEN; nur an claude weitergeben, nie global exportieren
    if not set -q GITHUB_PERSONAL_ACCESS_TOKEN; and command -q gh
        set -l token (gh auth token 2>/dev/null)
        if test -n "$token"
            GITHUB_PERSONAL_ACCESS_TOKEN=$token command claude $argv
            return
        end
    end
    command claude $argv
end
