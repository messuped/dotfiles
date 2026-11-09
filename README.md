
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
- **`.config/zsh/bindings.zsh`** — Custom keybindings (emacs mode): Ctrl+Arrow word movement, Ctrl+F fzf file picker,
  Up/Down history substring search.
- **`.config/zsh/fzf.zsh`** — fzf defaults (`fd` backend, Catppuccin-compatible UI options,
  `bat` preview). Custom `_fzf_file_no_hidden` widget bound to Ctrl+F.
- **`.config/zsh/plugins.zsh`** — Lightweight plugin manager (`_zplugin_load`): clones
  plugins from GitHub on first run, sources their plugin files. Managed plugins:
  `zsh-autosuggestions`, `zsh-history-substring-search`, `fast-syntax-highlighting`.
  `zplugin-update` helper updates all plugins via `git pull`.
- **`.config/zsh/prompt.zsh`** — Starship init; disables virtualenv prompt pollution.

## opencode (V2): software factory + second brain

The setup is project-agnostic. Clone, `stow .`, and it's ready.

| Agent | Mode | Role |
|-------|------|------|
| `foreman` | primary | Plans a change with you (grilling → spec → tickets), then builds it through subagents behind two human gates. Never edits repo code. |
| `builder` | subagent | Implements one ticket, test-first, and runs the verify commands. Can't touch git state. |
| `fixer` | subagent | Bug fixes: makes an approved failing test pass. Edits to test files are denied. |
| `critic` | subagent | Read-only adversarial reviewer from a different model family, for the plan and the diff. |
| `librarian` | all | Maintains the Zettelkasten wiki (`~/code/Zettelkasten`). |
| `archivist` | primary | Answers questions from the wiki. |

**Flow:**
1. Grill, spec, tickets, then a critic review.
2. ⛔ **Plan gate.**
3. Build: one fresh `builder` per ticket. Tickets marked HITL pause for you.
4. Verify, then a two-axis code review.
5. ⛔ **Implementation gate.**
6. One commit per ticket, `KEY Message`. `git commit` always asks; choose *Allow once*.

**Artifacts:** spec, tickets, `PROJECT.md`, glossary and ADRs live outside the repo, under
`${FACTORY_HOME:-~/code/Zettelkasten/raw/factory}/<repo>/`. A project's own `AGENTS.md`
is never modified.

**Skills:** `.config/opencode/skills/` holds unmodified copies of
[mattpocock/skills](https://github.com/mattpocock/skills); see `LICENSE-THIRD-PARTY.md`.
To update them, run this from the repo root, then bump the commit in `LICENSE-THIRD-PARTY.md`:

```sh
git clone --depth 1 https://github.com/mattpocock/skills /tmp/mp-skills
for s in $(ls .config/opencode/skills); do
  rsync -a --delete --exclude agents/ "$(find /tmp/mp-skills/skills -mindepth 2 -maxdepth 2 -type d -name "$s")/" ".config/opencode/skills/$s/"
done
```

**Machine-local settings** go in the untracked `~/.config/opencode/opencode.private.json`,
which `OPENCODE_CONFIG` loads. On a machine whose artifacts must stay out of the synced
brain (e.g. a work laptop), make these three changes:
- Set `FACTORY_HOME` in `work.zshenv`.
- Allow foreman to write there, in the overlay:
  `{"agents":{"foreman":{"permissions":[{"action":"edit","resource":"<path>/*","effect":"allow"}]}}}`
- Add work MCP servers and skill paths to the overlay, with tokens passed as `{env:VAR}`.

**Orca:**
- Run OpenCode in a **terminal** pane. Orca's chat view auto-approves permission prompts and turns off the question tool, which breaks the gates.
- Orca owns the worktrees. `foreman` refuses to build on the default branch.
- To send review notes during the implementation gate, use Orca's *Annotate AI Diff*.

## Secrets Strategy

Sensitive environment variables are intentionally **not tracked** in the repo. The
`.zshenv` sources two optional untracked files:

- `~/.secrets.zshenv` — personal secrets
- `~/.config/.work.zshenv` — work-specific environment variables

## CLI Toolchain

The configuration assumes the following tools are installed (typically via Homebrew):

`zsh`, `neovim`, `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`, `lf`, `starship`,
`lazygit`, `ghostty`
