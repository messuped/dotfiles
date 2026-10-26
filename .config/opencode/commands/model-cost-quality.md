---
description: Compare AI models on current cost, quality evidence, and workflow fit before changing agents
agent: orchestrator
---

Run a cost-and-quality analysis for newly available AI models. This is a research and recommendation command only: do not edit OpenCode, OMO-slim, agent, skill, or workflow configuration, and do not launch coding tasks merely to test a model.

You are the orchestrator: delegate web research on quality evidence to @librarian (in parallel per candidate) and config/model-availability lookups to @explorer; do the pricing fetch, cost math, synthesis, and report yourself.

The user may provide model names, provider names, role names, personal observations, or a link after the command. Use all supplied context. If no candidates are supplied, identify plausible new or changed models from the current configuration and the latest provider/model information available to you, then state exactly which candidates you evaluated.

## 1. Establish the comparison set

- Read the current global configuration when available (`~/.config/opencode/opencode.json` and `~/.config/opencode/oh-my-opencode-slim.json`), plus tracked configuration in the current dotfiles repository when relevant. Include active and disabled agents, their models, variants/effort levels, and role names.
- Discover and include every configured personal-notes role in scope. At minimum, cover `zettelkasten` for knowledge extraction/synthesis, atomic-note quality, links/tags/frontmatter, source fidelity, and duplicate or hallucinated notes, and `archivist` for its local/offline model, privacy, throughput, and structured archival/extraction fidelity. Include any other personal-notes roles found in the command/config.
- Treat the current model assigned to a role as the baseline for that role. Do not assume that replacing every occurrence of a model is desirable.
- Normalize aliases and provider prefixes, but preserve the exact model IDs used by the configuration.
- Compare like with like where possible: model family, provider, context tier, reasoning/variant level, and role. A cheap model at low effort is not evidence that the same model is suitable at maximum effort.
- Include the user-provided candidates and any obvious predecessor/successor pairs. If a model name cannot be verified, mark it as unresolved instead of inventing facts.

## 2. Gather authoritative cost data

Use this GitHub Copilot pricing page as the primary cost source and fetch it every time:

https://docs.github.com/en/enterprise-cloud@latest/copilot/reference/copilot-billing/models-and-pricing

Plain fetches may be redirected to an `llms.txt` index. If so, fetch the markdown body via `https://docs.github.com/api/article/body?pathname=/en/copilot/reference/copilot-billing/models-and-pricing` (or set `prefer_llms_txt: never`). Never use remembered prices; if the page cannot be fetched, say so and stop the cost section.

Also verify each candidate exists for the user's provider with `opencode models github-copilot --refresh` (and other configured providers); pricing-page presence does not prove OpenCode availability.

Record the page date or retrieval date, exact model name, context tier/threshold, input price, cached-input price, cache-write price when listed, and output price. Prices are per one million tokens. Include the source URL beside the figures.

Important cost rules:

- Distinguish input, cached input, cache write, and output prices. Do not compare only the input price.
- Use the correct long-context tier when a model crosses its threshold.
- Default workload assumptions (override if the user supplies better ones; state cache hit rate used): small = 20K input / 2K output; normal = 150K input (70% cached) / 15K output; deep = 500K input (80% cached) / 60K output. Keep them identical across models.
- Calculate a few representative workloads rather than presenting only a price table. At minimum compare a small task, a normal coding task, and a deep review/exploration task with explicit input/output assumptions.
- Use this calculation when enough prices and token assumptions are available: `(input_tokens * input_rate + cached_input_tokens * cached_rate + cache_write_tokens * cache_write_rate + output_tokens * output_rate) / 1,000,000`.
- Show both absolute estimated cost and percentage change versus the baseline. Make assumptions visible and do not imply that token price equals total task cost.
- Account for the configured reasoning/variant level and likely output length when discussing cost. If the pricing page does not expose effort-level pricing, say so.
- Do not treat Copilot plan allowances, AI credits, legacy request multipliers, or token prices as interchangeable. Explain which billing regime the figures describe if relevant.
- For local/offline agents, explicitly check that the local model is available and measure or report representative performance (including throughput and latency). Compare privacy and latency separately from hosted token cost; use `N/A` for hosted-pricing math when it is inapplicable rather than forcing an estimate.

## 3. Gather quality evidence

Search for recent quality and behavior evidence for each candidate and its baseline. Prefer sources in this order:

1. The user's own observations and task history.
2. Repeated first-hand reports from credible practitioners, including the feedback supplied in the prompt.
3. Reproducible evaluations, benchmarks, release notes, and technical documentation.
4. Vendor claims, clearly labeled as vendor claims.

Also read the persistent evidence log at `~/code/model-evidence.md` if it exists (user observations and pasted feedback from earlier runs). At the end, offer to append new user-supplied evidence there in the format below; only write it if the user agrees. This is the only file this command may write.

Use the latest available information, but do not treat recency as proof. For each important claim, record:

- Source and date
- Whether it is first-hand, anecdotal, benchmark-based, or a vendor claim
- Task type and model variant/effort level
- The observed behavior
- Confidence: high, medium, or low

Pay special attention to reports of laziness, shallow exploration, premature conclusions, tool-use quality, review depth, test generation, coding accuracy, instruction following, speed, and consistency. Separate "faster" from "better" and "cheaper" from "more cost-effective". Treat a single anecdote as a hypothesis, not a verdict.

If online search is unavailable, say so and use only the supplied evidence and authoritative pricing data. Never fabricate community sentiment, benchmarks, release dates, or model capabilities.

## 4. Use the user's evidence correctly

Personal experience is strongest for this workflow; team feedback is useful but not controlled; benchmarks describe benchmark tasks only; announcements show intent, not quality.

When the user has not supplied personal observations, say that the recommendation is provisional and list the smallest useful observations to collect next. Do not ask the user to run a full benchmark suite unless that is necessary; propose a compact evaluation set instead.

If direct personal evidence is important to the decision but absent from the prompt and available files, ask up to three focused questions before finalizing. Ask for the model and variant, task type, outcome, corrections required, and approximate number of observations. Do not claim to have personal evidence that was not supplied.

## 5. Evaluate role fit

Assess each candidate separately for the roles actually present in the configuration, such as:

- Orchestrator: planning, delegation, context management, and reliable synthesis
- Oracle/reviewer: deep reasoning, adversarial analysis, and thoroughness
- Librarian/researcher: web research, source quality, and citation discipline
- Explorer: fast repository search and pattern discovery
- Fixer/implementer: accurate edits, tool use, and test awareness
- Zettelkasten: knowledge extraction and synthesis, atomic-note quality, links/tags/frontmatter, source fidelity, and detection of duplicate or hallucinated notes
- Archivist: local/offline model suitability, privacy, throughput, and structured archival/extraction fidelity
- Designer or other specialist roles when configured

For every configured personal-notes role, assess the role's model separately and include the relevant quality criteria above. For `archivist`, explicitly verify local-model availability and performance before recommending a change. Do not recommend a single global winner when the evidence suggests role-specific choices. A model can be a good default for simple implementation while being a poor choice for deep review. Consider whether a lower-cost model is good enough for a role, not merely whether it is the strongest model overall.

## 6. Produce the report

Return a concise but evidence-backed report with these sections:

### Executive recommendation

State:

- Keep, trial, replace, or avoid for each affected role
- The exact model and variant/effort level recommended
- Whether the evidence is strong enough to change configuration now

### Current configuration

List relevant role -> model -> variant assignments, including disabled assignments when they are relevant to the comparison. Always list every configured personal-notes role, including `zettelkasten` and `archivist`, and identify whether each model is hosted or local/offline.

### Cost comparison

Use a table with:

| Model | Role/baseline | Input | Cached input | Cache write | Output | Small task | Normal task | Deep task | Cost change |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|

Use `N/A` when a field is not published or hosted-pricing math is inapplicable to a local/offline model. Put workload assumptions below the table. Report local privacy, availability, throughput, and latency separately rather than treating them as token cost.

### Quality evidence

Summarize the strongest evidence per candidate and label each item with source type and confidence. Explicitly call out disagreements, especially reports that differ by variant/effort level or task complexity.

### Role-by-role decision matrix

Use a table with:

| Role | Current | Candidate | Quality fit | Cost fit | Main risk | Recommendation |
|---|---|---|---|---|---|---|

### Trial plan

If the decision is uncertain, propose a small, controlled trial using representative tasks already available in the user's workflow. Include personal-notes tasks for every configured role: for `zettelkasten`, extraction/synthesis, atomic-note quality, links/tags/frontmatter, source fidelity, and duplicate/hallucination checks; for `archivist`, structured archival/extraction, wiki-grounding, local availability, throughput, latency, and privacy. Specify what to record: completion quality, corrections, review depth, tool calls, wall-clock time, output tokens if visible, estimated hosted cost when applicable, and local performance separately. Do not run the trial automatically.

### Sources and unknowns

List URLs, retrieval dates, unresolved model names, missing pricing fields, weak evidence, and assumptions. Make clear which conclusions came from the user's observations.

### Suggested config changes

Show exact, unapplied diffs (role, model ID, variant) for `oh-my-opencode-slim.json` or agent files. Do not apply them.

Finish with one direct sentence: whether to update any agents now, which ones, or whether to wait for more evidence.

## 7. Guardrails

- This command is advisory. Do not modify configuration or commit changes (the only permitted write is the optional evidence log, with consent).
- Never print secrets or API keys found in config files (e.g. private/provider option blocks).
- Never present an unverified model as available or compatible with the user's provider.
- Never turn a vendor marketing claim into a quality fact.
- Never claim a model is "better" without naming the task type, comparison baseline, and effort/variant level.
- Never hide uncertainty behind a single overall score.
- If the prompt contains a pasted discussion, cite it as user-supplied community feedback rather than as independently verified evidence.

Additional user context:

$ARGUMENTS

Useful input format, when supplying personal evidence:

`model | variant/effort | role or task | outcome | corrections/rework | number of observations`
