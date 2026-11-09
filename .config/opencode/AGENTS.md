# Global instructions

## Factory artifacts

Planning and review artifacts live outside the repo. Never write them into the repo.

- Root: `${FACTORY_HOME:-$HOME/code/Zettelkasten/raw/factory}`. Resolve it with the shell.
- Repo key: the main checkout's folder name, the same in every worktree: `basename "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"`.
- `<root>/<repo>/PROJECT.md`: project profile (verify commands, conventions, known agent mistakes). It supplements the repo's own AGENTS.md, which is never edited.
- `<root>/<repo>/<change>/`: one folder per change. `<change>` is the ticket key from the branch name (e.g. `ABC-123`), else a kebab-case slug.

## Agent skills

A project's own `## Agent skills` block overrides this one.

### Issue tracker

Local markdown, outside the repo:

- Spec: `<root>/<repo>/<change>/spec.md`. Tickets: `<root>/<repo>/<change>/issues/NN-<slug>.md`, one file per ticket, numbered from `01`.
- Wherever a skill says `.scratch/<feature-slug>/`, use `<root>/<repo>/<change>/`.
- Triage state is a `Status:` line near the top of each file. Comments append under `## Comments`.
- An external ticket (Jira, GitHub, …) is read through whatever tracker MCP or CLI is available. Never write to it unless asked.

### Triage labels

The canonical role strings, unchanged: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`.

### Domain docs

Single-context. `GLOSSARY.md` and ADRs live in `<root>/<repo>/` (`GLOSSARY.md`, `adr/NNNN-<slug>.md`), not in the repo.

## Git

- Commit message: one line, `<KEY> <Imperative summary>`, e.g. `ABC-123 Add retry to fetcher`. KEY comes from the branch name; without one, the summary alone. No body, no trailers.
- Never push unless asked. Never force-push or rewrite published history.
