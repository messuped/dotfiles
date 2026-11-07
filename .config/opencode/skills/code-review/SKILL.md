---
name: code-review
description: Manual only. Two-family code review of the current branch against upstream/develop. Runs @review-a (Claude Sonnet) and @oracle (OpenAI) in parallel on the same diff, verifies their findings, and writes a report.
disable-model-invocation: true
---

# Code review (two model families)

Review the current worktree's branch against `upstream/develop` with two reviewers from different model families, then merge, verify and write one report. The user invoked this skill on purpose: always run both reviewers, whatever the diff size.

The change may be the user's own work or a colleague's PR checked out in this worktree. Do not assume the user wrote it.

## Reviewers

| Reviewer | Family | Why |
|---|---|---|
| `@review-a` | Anthropic, must be Claude Sonnet | Read-only reviewer with a fixed output format |
| `@oracle` | OpenAI | Read-only advisor, different family from `@review-a` |

You cannot be a reviewer yourself: do the synthesis, not a third review. Never use `@fixer`.

### Pre-flight (stop on failure)
1. Read `~/.config/opencode/agents/review-a.md`. Its `model` must be a Claude Sonnet model (e.g. `github-copilot/claude-sonnet-5.5`).
2. Read the active preset's `oracle.model` in `~/.config/opencode/oh-my-opencode-slim.json`. It must be an OpenAI GPT model.
3. If either check fails, or both resolve to the same family, stop and tell the user what is configured. Do not silently substitute another reviewer.

## Process

### 1. Establish scope
- Base is always `upstream/develop`. Diff command: `git diff upstream/develop...HEAD`. If there is no `upstream` remote or no `develop` ref, stop and ask. Do not guess another base. Do not fetch.
- Also record the HEAD sha, base sha, branch name, and `git diff --stat`.
- If the diff is empty, stop and tell the user.
- If the diff is large (roughly more than 1500 changed lines), stop and offer to split by directory or concern. Wait for the answer.
- Uncommitted changes are not part of the diff. If `git status --short` shows any, mention it in one line and continue.

### 2. Build one evidence packet
Both reviewers get the same packet, because `@review-a` has no shell access:
- `SCOPE`: branch, base sha, head sha, the exact command, the stat.
- `DIFF`: the full diff.
- `JIRA TICKET`: look for a ticket key in the branch name, commit messages and any PR text the user gave you. If you find one and a Jira tool is available, fetch the title, description and acceptance criteria. Otherwise write "none provided".
- `CONTEXT`: PR description or intent from the user, if any.
- `TESTS`: test output you already have, if any. Do not run tests just for this.
- `FOCUS`: anything the user asked to look at harder.

Do not add your own opinion of the code.

### 3. Dispatch both reviewers in parallel
Send both in the same step.
- `@review-a`: use its input contract (`JIRA TICKET`, `BRANCH DIFF`, `DEVELOPER BRIEF`, `IMPLEMENTATION SUMMARY`, `TEST RESULTS`; "none" for missing parts). Put `SCOPE`, `CONTEXT` and `FOCUS` inside `DEVELOPER BRIEF`.
- `@oracle`: the same packet plus: "Review this change as an independent senior reviewer. Cover correctness, bugs and edge cases, security, performance, tests, and maintainability. Do not edit files. For each finding give severity (CRITICAL, MAJOR, MINOR, NIT), a short title, an explanation, and the location as the class (or function/module) name plus file and line numbers. End with open questions."

If a reviewer fails or times out, retry it once. If it still fails, stop and tell the user; do not produce a single-family report unless they agree.

Do not share one reviewer's output with the other.

### 4. Verify
You can read the code; the reviewers may be wrong or working from the diff alone.
- For every CRITICAL and MAJOR finding, open the file and confirm the problem exists at that location and is not handled elsewhere. Correct the class name and line numbers if needed.
- Mark each finding `confirmed`, `plausible` (could not fully verify) or `dismissed` (one-line reason). Never drop a finding silently.

### 5. Write the report
Write a markdown file, like `/handoff` does, to `~/code/Zettelkasten/raw/review-<ticket-or-branch-slug>-<YYYY-MM-DD>.md` (lowercase kebab-case slug; ticket key if one was found, else the branch name). The file is always written first. If that directory does not exist, write `review-<slug>-<YYYY-MM-DD>.md` in the current directory instead. Do not overwrite an existing file: add `-2`, `-3`, and so on.

Structure (omit empty sections):

```markdown
# Review — <ticket key or branch> — <short change title>

## Scope
**Branch:** <branch>  **Base:** upstream/develop @ <sha>  **Head:** <sha>
**Ticket:** <key and title, or none>
**Reviewers:** @review-a (<model>), @oracle (<model>)
**Verdict:** Ready | Ready after minor fixes | Needs changes | Blocked — <one sentence>

### Change summary
<What the change does, in plain language, from the diff and ticket.>

---

## Findings

### 1. <Title of change/issue>
**Severity:** CRITICAL | MAJOR | MINOR | NIT
**Raised by:** both | @review-a | @oracle
**Status:** confirmed | plausible
**Location:** `<ClassName>` (or function/module) — `path/to/File.ext:<start>-<end>`
**Explanation:** <What is wrong or risky and why it matters.>
**Suggestion:** <Concrete fix.>

(repeat, ordered by severity, then findings both reviewers raised first)

---

## Disagreements
- **<Topic>**: @review-a says …; @oracle says …; assessment: …

## Dismissed
- **<Title>** (<reviewer>): <reason>

## Positives
<Specific things done well, merged from both.>

## Open Questions
<For the author, merged from both.>
```

Every finding needs a class (or function/module) name and file with line numbers; if a finding is about something that is missing, point to where it should live.

### 6. Report to the user
Print the full report in the chat, using the same structure and content as the file, so the user does not have to open it. Add one final line with the path of the file written. Then offer to fix findings and wait for the user to choose which ones.

## Guardrails
- Review only. Do not edit code, apply fixes, commit or push.
- Do not paste secrets or credentials from the diff into reviewer prompts. If the diff contains any, flag it as a finding and redact it in the packet.
- Do not pad. If the change is clean, say so briefly and still write the short report.
