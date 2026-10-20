# claude-skill-self-improve

A Claude Code skill that runs a recurring retro: it reviews recent work, extracts general,
reusable lessons and folds them into `~/.claude/` (CLAUDE.md, rules, memory, skills, agents),
pruning stale entries as it goes. A `UserPromptSubmit` hook nudges it every N turns; it can
also be run by hand with `/self-improve`.

> [!NOTE]
> This skill is a starting point, not a finished product. It is meant to be adapted to your
> own use case: edit `SKILL.md` to match where your lessons should live, what counts as a
> good lesson for your work, and how often the retro should run.

```
SKILL.md                          the skill
scripts/self-improve-counter.sh   turn-counter hook
```

## Install

1. Clone the skill into your skills folder:

   ```bash
   git clone git@github.com:JonnaMat/claude-skill-self-improve.git ~/.claude/skills/self-improve
   ```

2. Install the hook script:

   ```bash
   mkdir -p ~/.claude/hooks && cp ~/.claude/skills/self-improve/scripts/self-improve-counter.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/self-improve-counter.sh
   ```

3. Register the hook in `~/.claude/settings.json` (merge with any hooks you already have):

   ```json
   {
     "hooks": {
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude/hooks/self-improve-counter.sh"
             }
           ]
         }
       ]
     }
   }
   ```

4. Restart Claude Code and check `/hooks` lists the `UserPromptSubmit` entry.

## How the hook works

On every prompt the script reads `session_id` from the hook's JSON payload, increments
`~/.claude/state/self-improve/<session_id>.count`, and every N-th turn prints a
`[self-improve]` line, which Claude Code adds to the conversation as context. The skill then
runs the retro (in the background when a subagent tool is available).

- Cadence: `SELF_IMPROVE_EVERY=30 claude` (default 20).
- Disable without removing the hook: `SELF_IMPROVE_EVERY=0`.
- Reset counters: delete `~/.claude/state/self-improve/*.count`.
- Each retro writes its summary to `~/.claude/state/self-improve/last-retro.md`, which the
  next retro reads.

## Scope

The retro writes only under `~/.claude/`. Lessons that belong in a project repo are listed in
its report as proposals for you to apply.
