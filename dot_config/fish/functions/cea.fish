function cea --wraps='chezmoi edit' --description 'chezmoi edit + apply'
    chezmoi edit $argv && chezmoi apply
end
