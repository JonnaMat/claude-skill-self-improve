---
name: self-improve
description: Recurring self-improvement retro for Claude Code. Review recent work, extract GENERAL reusable lessons, and fold them into the user's ~/.claude/ setup (CLAUDE.md, memory, skills, rules, agents). Use whenever the user says /self-improve, asks for a retro or "lessons learned", wants to make a fix or gotcha permanent, says "remember this for next time", or when the turn-counter hook injects a [self-improve] nudge. Also use when the user complains about re-explaining the same thing or Claude repeating a mistake — that is a retro trigger even if no one says "retro".
user-invocable: true
---

# Self-Improve (recurring retro)

Turn the friction and discoveries of recent work into **durable, general** improvements to
the user's `~/.claude/` setup. This is how the setup gets better over time instead of
re-learning the same lessons every session.

A `UserPromptSubmit` hook nudges this every ~20 turns (see **Triggering**). It can also be
invoked by hand with `/self-improve`.

**Scope of writes: only files under `~/.claude/`.** Never edit project repos, project
`CLAUDE.md` files, or anything outside `~/.claude/` during a retro. If a lesson belongs in a
repo, write it into the report as a proposed change and let the user apply it.

Within `~/.claude/` the retro may **add, rewrite and remove**: lines, sections, memory files,
rules, whole skills and agents. Pruning is part of the job, not an exception. Every removal is listed in the report with a
one-phrase reason so the user can veto it.

## The one rule: GENERAL, not task-specific

Only capture what will help a *future, different* task. "How to finish today's migration"
is not an improvement; "a synced file can silently revert, so re-verify a marker before
trusting a run" is. If a lesson only makes sense with this week's project nouns in it,
either generalize it or drop it.

A valid retro can end with **no edits**. Say so and stop — padding the config with weak
rules makes every future session worse, not better. The mirror image is just as valid: a
retro that only removes (a stale rule, a skill nobody invokes, a memory contradicted by
newer evidence) has improved the setup.

## Workflow

### 1. Gather signal (read-only, ~5 min)

Look at what happened since the last retro:

- The current conversation itself — this is the richest source. Reread it looking for the
  items below rather than skimming the last few turns.
- `~/.claude/CLAUDE.md`, `~/.claude/rules/`, `~/.claude/skills/*/SKILL.md`, and
  `~/.claude/projects/*/memory/MEMORY.md` (so you know what is already captured).
- `~/.claude/state/self-improve/last-retro.md` if it exists (what the previous retro did).
  (Project memory dirs start with `-`: read them with absolute paths or `./`, or `cat` parses
  the path as an option.)

Specifically hunt for:

- **Repeated friction**: the same fix applied more than once, a gotcha that bit twice, a
  manual step done repeatedly, a workaround you had to rediscover.
- **User corrections and re-asks**: anything the user corrected, rephrased, or had to ask
  for again. These are the highest-signal lessons — the user already paid for them once.
- **Wrong assumptions** about the environment, tools, formats, or preferences that turned
  out false.
- **Config friction**: a hook, permission, or setting that got in the way or that you
  wished existed.

### 2. Distil

Turn each candidate into a one-line, project-agnostic rule with a *why* and a *how to
apply*. Then check it against what already exists (CLAUDE.md, rules, skills, memory). If
it is already captured, discard it — or, if the existing version was clearly not enough to
prevent the repeat, sharpen that line instead of adding a second one.

### 3. Write it to the right home

Pick the **smallest durable place that will actually be re-read**:

| Lesson looks like… | Home | Notes |
|---|---|---|
| A one-line universal reflex ("always X before Y") | `~/.claude/CLAUDE.md` | Loads on **every** session, so its length is the scarce resource. Add the imperative only; put reasoning and examples elsewhere. Never let it drift back toward a wall of text. |
| A repeatable *procedure* (multi-step, needs explanation) | `~/.claude/skills/<name>/SKILL.md` | Default home for anything longer than a line. Prefer extending an existing skill over creating a near-duplicate. Skills cost nothing until invoked. |
| A rule scoped to a language, tool, or file type | `~/.claude/rules/<topic>.md` | Keeps CLAUDE.md short while staying auto-loaded. |
| A fact, preference, or pointer about the user or environment | Auto-memory under `~/.claude/projects/<project>/memory/` | One fact per file; add a one-line pointer in `MEMORY.md`. Follow the existing memory conventions there. |
| A *role* that needs a fresh context and its own tool set (reviewer, verifier, log reader) | `~/.claude/agents/<name>.md` | A subagent definition: frontmatter `name`, `description` (when to use it), `tools`, optional `model`; body is the brief. Only when the role has been needed more than once. |
| A fix to how this retro itself works | This skill, or the hook script | The retro is allowed to improve itself. |

When unsure between CLAUDE.md and a skill, choose the skill and leave a one-line pointer
in CLAUDE.md only if the lesson is universal.

#### Creating a new skill or agent

The retro may create them, not only extend them. Create a **skill** when a procedure
recurred (two sessions, or twice in one) and has a trigger the user actually says; it
needs `~/.claude/skills/<name>/SKILL.md` with frontmatter `name` and `description` (the
description is what triggers it, so put the user's own phrases in it), then the steps.
Create an **agent** when the lesson is "this kind of work goes better in a fresh context"
(an unanchored review, a long log read, a verifier that must not see the hypothesis):
`~/.claude/agents/<name>.md` with frontmatter `name`, `description`, `tools` (comma
separated), optional `model`, and a body that is the brief: goal, what to check, what
to report back and in what shape. Keep both short, and say in the report that a new
skill or agent was created so the user can veto it. Never create one from a single
occurrence; note it in the report as a candidate instead.

### 4. Prune as readily as you add

Every file under `~/.claude/` that auto-loads (CLAUDE.md, rules/, MEMORY.md) costs context
on every session; skills and agents cost attention in listings. Remove what no longer earns
its place:

- **Stale**: contradicted by newer evidence (a path that moved, a tool that now works, a
  workaround for a fixed bug). Delete it, or replace it with the current fact.
- **Duplicate**: the same lesson in two homes. Keep the one in the smallest durable place
  and delete the other.
- **Unused**: a skill or agent not invoked in the last several retros, or a memory whose
  subject is finished. Delete it; the git history of `~/.claude/` (if any) or the retro
  report is the record.
- **Superseded**: when a rewrite captures a lesson better, replace the old lines rather than
  stacking a second version next to them.

The user's own lines are not sacred either, but removing one needs a stated reason that the
user can check (it is wrong, duplicated, or obsolete), never "it seemed verbose". When in
doubt between deleting and keeping, delete and list it in the report; the user can restore
a line more easily than they can notice an accumulating one.

- Keep YAML frontmatter and JSON valid. After editing `settings.json` or a skill, reread it.
- No edits outside `~/.claude/`.

### 5. Report and record

End with a short bullet list: what was added or rewritten, what was **removed** (file or
line, one-phrase reason), and what was considered and dropped (one-phrase reason). Then write the same summary to
`~/.claude/state/self-improve/last-retro.md` so the next retro knows where it left off.

## What good lessons look like

- **Reliability gotchas**: state that silently reverts or goes stale; a number that is
  easy to read wrong (verify on the source of truth, not a subagent's grabbed value).
- **Environment facts**: shell quirks, tool versions, paths, where things actually live.
- **Tool-dev discipline**: compile-check → validate on one canary → fan out.
- **Session hygiene**: keep a live working-set (running / queued / blocked-on-user) in
  tasks or memory so a compaction or context switch doesn't lose a thread.
- **Communication preferences**: how the user likes answers, reports, or confirmations.

## Triggering

The hook `scripts/self-improve-counter.sh` runs on `UserPromptSubmit`, counts turns per
session, and every N turns prints a
`[self-improve]` nudge that Claude Code adds to the conversation as context.

On a nudge, run the retro **in the background** if a background agent/subagent tool is
available, so the active work isn't paused and the main context stays clean. Otherwise run
it inline but keep it brief. Don't start a second retro while one is still running; if the
user is mid-task and the timing is bad, say "retro due, I'll do it at the next pause" and
honour that.
