function cear --wraps='chezmoi edit' --description 'chezmoi edit + apply + clear + reload'
    chezmoi edit $argv && chezmoi apply && clear && reload
end
