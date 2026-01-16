#!/bin/bash

# context-monitor.sh
#
# Claude Code Hook Script
# Runs on PostToolUse event (after every file edit, bash command, etc.)
#
# Purpose: Track tool executions and trigger context checkpoint check
# every 4-5 steps
#
# Cost: ZERO tokens (pure bash, no AI invocation)
#
# Configuration:
#   STEP_THRESHOLD = How many steps before triggering (4-5 recommended)
#   COUNTER_FILE = Where to store the execution counter
#
# Integration: Adapted for claude-code-starter template
# - Dynamically detects active work item from docs/_index.md
# - Supports Epic/Task/Subtask hierarchy
# - Works with *-context.md files (not standalone task.md)

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

# Number of steps before triggering context check
# Recommended: 4-5
# Too low: Too many reminders
# Too high: Context gets too full
STEP_THRESHOLD=4

# Where to store the step counter between invocations
COUNTER_FILE="${CLAUDE_PROJECT_DIR}/.claude/.step-counter"

# Temporary file for communication (if needed)
CONTEXT_FILE="${CLAUDE_PROJECT_DIR}/.claude/.last-context-check"

# ============================================================================
# INITIALIZATION
# ============================================================================

# Create .claude directory if it doesn't exist
mkdir -p "$(dirname "$COUNTER_FILE")"

# Initialize counter file if it doesn't exist
if [ ! -f "$COUNTER_FILE" ]; then
    echo "0" > "$COUNTER_FILE"
fi

# ============================================================================
# LOGIC
# ============================================================================

# Read current counter value
CURRENT_COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")

# Increment the counter
CURRENT_COUNT=$((CURRENT_COUNT + 1))

# Save updated counter
echo "$CURRENT_COUNT" > "$COUNTER_FILE"

# Check if we've hit the threshold
if [ $((CURRENT_COUNT % STEP_THRESHOLD)) -eq 0 ]; then

    # ========================================================================
    # THRESHOLD HIT - TIME FOR CONTEXT CHECK
    # ========================================================================

    # Parse _index.md to find active work item
    INDEX_FILE="${CLAUDE_PROJECT_DIR}/docs/_index.md"
    WORK_ID=""
    CONTEXT_FILE_PATH=""

    if [ -f "$INDEX_FILE" ]; then
        # Extract: "**Last worked on**: E001-T001 - name"
        ACTIVE_ITEM=$(grep "^\*\*Last worked on\*\*:" "$INDEX_FILE" 2>/dev/null | head -1)

        if [ -n "$ACTIVE_ITEM" ]; then
            # Parse ID (E001, E001-T001, or T001)
            WORK_ID=$(echo "$ACTIVE_ITEM" | sed -E 's/.*: ([ET][0-9]+-?[T]?[0-9]*).*/\1/')

            # Determine context file path by pattern
            if [[ "$WORK_ID" =~ ^E[0-9]+-T[0-9]+$ ]]; then
                # Epic Task: E001-T001
                EPIC_ID=$(echo "$WORK_ID" | cut -d'-' -f1)
                EPIC_NAME=$(find "${CLAUDE_PROJECT_DIR}/docs/epics" -maxdepth 1 -type d -name "${EPIC_ID}-*" 2>/dev/null | head -1 | xargs basename)
                TASK_NAME=$(find "${CLAUDE_PROJECT_DIR}/docs/epics/${EPIC_NAME}/Tasks" -maxdepth 1 -type d -name "${WORK_ID}-*" 2>/dev/null | head -1 | xargs basename)
                TASK_ID="${WORK_ID#*-}"
                CONTEXT_FILE_PATH="docs/epics/${EPIC_NAME}/Tasks/${TASK_NAME}/${TASK_ID}-context.md"

            elif [[ "$WORK_ID" =~ ^E[0-9]+$ ]]; then
                # Epic only: E001
                EPIC_NAME=$(find "${CLAUDE_PROJECT_DIR}/docs/epics" -maxdepth 1 -type d -name "${WORK_ID}-*" 2>/dev/null | head -1 | xargs basename)
                CONTEXT_FILE_PATH="docs/epics/${EPIC_NAME}/${WORK_ID}-context.md"

            elif [[ "$WORK_ID" =~ ^T[0-9]+$ ]]; then
                # Standalone task: T001
                TASK_NAME=$(find "${CLAUDE_PROJECT_DIR}/docs/tasks" -maxdepth 1 -type d -name "${WORK_ID}-*" 2>/dev/null | head -1 | xargs basename)
                CONTEXT_FILE_PATH="docs/tasks/${TASK_NAME}/${WORK_ID}-context.md"
            fi
        fi
    fi

    # Display reminder with work item info
    cat >&2 << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                       🔔 CHECKPOINT REMINDER                              ║
║                    Context Auto-Tracking Enabled                          ║
╚════════════════════════════════════════════════════════════════════════════╝

EOF

    cat >&2 << EOF
✓ Completed $CURRENT_COUNT steps since last checkpoint

EOF

    if [ -n "$WORK_ID" ]; then
        cat >&2 << EOF
📂 Active Work: $WORK_ID
📄 Context File: $CONTEXT_FILE_PATH

EOF
    fi

    cat >&2 << 'EOF'
📊 Context Usage: Check by running /check-context

Would you like to create a checkpoint? This will:
  • Check current context percentage (via /context)
  • Auto-generate next 5 steps based on your progress
  • Update your *-context.md file with session notes
  • Create a git commit with checkpoint
  • Prepare handoff for next session

🎯 To checkpoint, run: /check-context

Or continue working - you'll be reminded after 4 more steps.

╚════════════════════════════════════════════════════════════════════════════╝

EOF

    # Reset counter for next cycle
    echo "0" > "$COUNTER_FILE"

fi

# ============================================================================
# SUCCESS
# ============================================================================

# Exit with success (0) - this is non-blocking, we never want to interrupt
# the user's work
exit 0
