# =========================================================
# Keybindings
# =========================================================

# Option+Right/Left -> move by word (macOS)
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# Ctrl+F -> fzf file picker (no hidden files)
bindkey '^F' _fzf_file_no_hidden

# Up/Down -> history search by substring
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down