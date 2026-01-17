---
description: Check context at 70% threshold, then generate handoff
model: sonnet
allowed-tools: [Bash]
---

Check context: $ARGUMENTS

## What This Command Does

Intelligent wrapper around `/work:generate-handoff` that:
1. Checks current context usage
2. Only generates handoff if >= 70% threshold
3. Passes through all arguments/flags to generate-handoff

**Use this for:** Normal workflow with automatic threshold checking
**Use `/work:generate-handoff` for:** Manual checkpoint at any context %

---

## Step 1: Check Current Context

Run the `/context` command to get token usage:

```bash
/context
```

**Parse output:**
- Look for: `Token usage: X/200000` or similar format
- Extract: current tokens (X) and total tokens (200000)
- Calculate percentage: `(X / 200000) * 100`

**Alternative regex patterns** (in case format differs):
- `Token usage: (\d+)/(\d+)`
- `(\d+) / (\d+) tokens`
- `Context: (\d+)/(\d+)`

**If /context command fails:**
```
⚠️  Could not determine context usage automatically.

Please enter current context percentage manually (e.g., 75):  _
```

Wait for user input, then use that percentage.

Store: `CONTEXT_PCT`

---

## Step 2: Display Context Status

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 CONTEXT CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Token usage: {X} / 200,000
Current usage: {CONTEXT_PCT}%
Threshold: 70%
Status: {STATUS}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Where `{STATUS}` is:
- If < 70%: `⚪ Below threshold`
- If >= 70%: `✓ THRESHOLD MET`

---

## Step 3: Evaluate Threshold

### If Context < 70%

```
✅ Context is fine ({CONTEXT_PCT}%).

Continue working. Checkpoint recommended at 70%+ or when you want to save progress.

To create a manual checkpoint now, run:
  /work:generate-handoff {CURRENT_ARGS}
```

Exit cleanly. Do not proceed to generate-handoff.

### If Context >= 70%

```
⚠️  Context at {CONTEXT_PCT}% - checkpoint recommended.

Generating handoff...
```

Proceed to Step 4.

---

## Step 4: Call generate-handoff

Internally execute the `/work:generate-handoff` command with all arguments passed through:

```
Arguments to pass: $ARGUMENTS (preserve flags like --auto-approve)
```

The generate-handoff command will handle:
- Finding active work item
- Analyzing git history
- Generating steps
- User approval
- Saving handoff

**Simply pass control to generate-handoff and let it complete.**

---

## Error Handling

**Context percentage cannot be determined:**
```
⚠️  Unable to parse context usage from /context command.

Please enter context percentage manually (0-100): _
```

Wait for user input, validate it's a number between 0-100, then proceed.

**Invalid manual input:**
```
Invalid input. Please enter a number between 0 and 100.
```

Ask again.

---

## Examples

**Example 1: Below threshold**
```
User: /work:check-context

📊 CONTEXT CHECK
Token usage: 80,324 / 200,000
Current usage: 40%
Threshold: 70%
Status: ⚪ Below threshold

✅ Context is fine (40%).
Continue working. Checkpoint recommended at 70%+.
```

**Example 2: Above threshold**
```
User: /work:check-context E001-T002

📊 CONTEXT CHECK
Token usage: 147,324 / 200,000
Current usage: 74%
Threshold: 70%
Status: ✓ THRESHOLD MET

⚠️  Context at 74% - checkpoint recommended.
Generating handoff for E001-T002...

[generate-handoff takes over]
```

**Example 3: With auto-approve flag**
```
User: /work:check-context --auto-approve

📊 CONTEXT CHECK
Token usage: 152,000 / 200,000
Current usage: 76%
Status: ✓ THRESHOLD MET

Generating handoff with auto-approve...

[generate-handoff skips approval, saves immediately]
```

---

## Notes

- This is a thin wrapper - all logic lives in `/work:generate-handoff`
- Use this for normal workflow (hook reminds you to run this)
- Hook from T001 triggers reminder every 4 steps
- Threshold is fixed at 70% (v2 will make it configurable)
- Pass-through design keeps commands modular and composable
