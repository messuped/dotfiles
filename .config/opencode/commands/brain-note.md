---
description: Write a raw second-brain note of this session (what was done, problems, decisions) to ~/code/Zettelkasten/raw/ for the librarian to ingest.
---

Write a session note for the personal Zettelkasten, based on this conversation so far.

## 1. Extract

- **Ticket keys**: any keys mentioned (e.g. `ABC-123`), with their goal if it was discussed.
- **What we did**: concrete work completed: files, features, configs, commands.
- **Problems and resolutions**: every issue or blocker, its root cause if known, and how it was resolved.
- **Reasoning and decisions**: why one approach won, which trade-offs were weighed, what we decided not to do.
- **Files changed**: key files and what changed in each.
- **Notes**: discoveries, surprises, open follow-ups.

Leave out secrets, tokens, internal hostnames and personal data.

## 2. Filename

`<slug>-<YYYY-MM-DD>.md`. The slug is the main ticket key in lowercase (e.g. `abc-123`), or else a short kebab-case topic.

## 3. Write

Write to `~/code/Zettelkasten/raw/<filename>`, leaving out sections that don't apply:

```markdown
# <KEY> — <Title>   (or # <Topic>)

## Goal
<What the work was for, in plain language.>

## What We Did
<Concrete summary.>

## Problems & Resolutions
### 1. <Problem>
**Problem:** … **Root cause:** … **Fix:** …

## Reasoning & Decisions
- **<Decision>**: <why; what was rejected>

## Files Changed
| File | Change |
|------|--------|

## Notes
<Follow-ups, open questions, things to watch.>
```

## 4. Report

Reply with one line, `Written: ~/code/Zettelkasten/raw/<filename>`. The note stays raw so the user can amend it before asking `@librarian` to ingest it.
