
# Dotfiles Repository — Overview

**Management tool:** GNU Stow

## Purpose

A personal dotfiles repository that uses [GNU Stow](https://www.gnu.org/software/stow/) to
symlink configuration files from `~/dotfiles/` into the correct locations under `$HOME`.
This lets all configuration files be tracked in a single git repo while appearing to each
tool in its expected location (`~/.config/<tool>/`, `~/.zshrc`, etc.).

## Managed Configurations

| Area | Path in repo | Tool |
|------|-------------|------|
| Zsh shell | `.zshenv`, `.zshrc`, `.config/zsh/` | Zsh |
| Terminal emulator | `.config/ghostty/` | Ghostty |
| Editor | `.config/nvim/` | Neovim |
| Prompt | `.config/starship.toml`, `.config/oh-my-posh/` | Starship / Oh My Posh |
| File manager | `.config/yazi/` | Yazi |
| Code editor | `.config/zed/` | Zed |
| AI coding tool | `.config/opencode/` | opencode |

## Shell Setup (Zsh)

The shell configuration is modular, split across several sourced files:

- **`.zshenv`** — XDG variables, `$EDITOR`, `$PATH`, `$MANPAGER`, opencode config path, and
  optional sourcing of untracked secrets files.
- **`.zshrc`** — History settings, shell options, zoxide init, completion system, fzf
  key-bindings, and `source` calls for each module in `.config/zsh/`.
- **`.config/zsh/aliases.zsh`** — Aliases: `eza` (as `ls`/`ll`/`la`/`tree`), `bat` (as
  `cat`), `nvim` (as `vim`), `rg` (as `grep`), git shortcuts, `lazygit`.
  Includes an `lf()` wrapper that follows the current directory on exit.
- **`.config/zsh/bindings.zsh`** — Custom keybindings hooked into `zvm_after_init` so they
  survive `zsh-vi-mode`'s binding reset: Ctrl+Arrow word movement, Ctrl+F fzf file picker,
  Up/Down history substring search.
- **`.config/zsh/fzf.zsh`** — fzf defaults (`fd` backend, Catppuccin-compatible UI options,
  `bat` preview). Custom `_fzf_file_no_hidden` widget bound to Ctrl+F.
- **`.config/zsh/plugins.zsh`** — Lightweight plugin manager (`_zplugin_load`): clones
  plugins from GitHub on first run, sources their plugin files. Managed plugins:
  `zsh-autosuggestions`, `zsh-history-substring-search`, `fast-syntax-highlighting`.
  `zplugin-update` helper updates all plugins via `git pull`.
- **`.config/zsh/prompt.zsh`** — Starship init; disables virtualenv prompt pollution.

## opencode Agents

Stored in `.config/opencode/agents/`. Current agents include: `architect-designer`,
`archivist`, `implementation-specialist`, `librarian`, `plan-critic-a`, `plan-critic-b`,
`requirements-clarifier`, `review-a`, `review-b`, `task-planner`, `tech-lead`,
`test-automation-engineer`, `update-agents`, `wiki`.

## Secrets Strategy

Sensitive environment variables are intentionally **not tracked** in the repo. The
`.zshenv` sources two optional untracked files:

- `~/.secrets.zshenv` — personal secrets
- `~/.config/.work.zshenv` — work-specific environment variables

## CLI Toolchain

The configuration assumes the following tools are installed (typically via Homebrew):

`zsh`, `neovim`, `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`, `lf`, `starship`,
`lazygit`, `ghostty`
