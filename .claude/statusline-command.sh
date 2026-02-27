#!/bin/bash

# Read JSON input
input=$(cat)

# Extract basic information
model_full=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Shorten model name
# Handle both display names like "Claude Opus 4.6" and model IDs like "us.anthropic.claude-opus-4-6-v1"
if [[ "$model_full" == *"anthropic"* || "$model_full" == claude-* ]]; then
    # Model ID format: extract the model name part and format it nicely
    # us.anthropic.claude-opus-4-6-v1 -> Opus 4.6
    model=$(echo "$model_full" | sed -E 's/.*claude-(opus|sonnet|haiku)-([0-9])-([0-9]).*/\1 \2.\3/' | awk '{print toupper(substr($1,1,1)) substr($1,0) " " $2}' | sed 's/  / /')
    # Simpler: just extract and capitalize
    model=$(echo "$model_full" | sed -E 's/.*claude-(opus|sonnet|haiku)-([0-9]+)-([0-9]+).*/\1 \2.\3/' | awk '{printf "%s%s %s", toupper(substr($1,1,1)), substr($1,2), $2}')
else
    # Display name format: just remove "Claude " prefix
    model=$(echo "$model_full" | sed -E 's/^Claude[[:space:]]+//')
fi

# Get worktree name (last component of the path)
worktree=$(basename "$cwd")

# Get current git branch (skip optional locks for speed)
branch=$(cd "$cwd" 2>/dev/null && git -c advice.waitingForLock=false rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-branch")

# Extract context window information
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Extract task and agent counts
total_tasks=$(echo "$input" | jq -r '.tasks.total // 0')
pending_tasks=$(echo "$input" | jq -r '.tasks.pending // 0')
completed_tasks=$(echo "$input" | jq -r '.tasks.completed // 0')
agents_spawned=$(echo "$input" | jq -r '.agents.spawned // 0')

# Format context info
if [ -n "$used_pct" ]; then
    context_info="ctx:${used_pct}%"
else
    context_info="ctx:0%"
fi

# Build task/agent info
if [ "$total_tasks" -gt 0 ] || [ "$agents_spawned" -gt 0 ]; then
    task_agent_info=""

    if [ "$total_tasks" -gt 0 ]; then
        task_agent_info="tasks:${total_tasks}"
        if [ "$completed_tasks" -gt 0 ]; then
            task_agent_info="${task_agent_info}(✓${completed_tasks})"
        fi
    fi

    if [ "$agents_spawned" -gt 0 ]; then
        if [ -n "$task_agent_info" ]; then
            task_agent_info="${task_agent_info} "
        fi
        task_agent_info="${task_agent_info}agents:${agents_spawned}"
    fi

    # Format: [model] [context] [tasks/agents] [worktree] [branch]
    printf "\033[01;36m%s\033[00m | \033[01;33m%s\033[00m | \033[01;34m%s\033[00m | \033[01;32m%s\033[00m | \033[01;35m%s\033[00m" \
        "$model" \
        "$context_info" \
        "$task_agent_info" \
        "$worktree" \
        "$branch"
else
    # Format without task/agent info: [model] [context] [worktree] [branch]
    printf "\033[01;36m%s\033[00m | \033[01;33m%s\033[00m | \033[01;32m%s\033[00m | \033[01;35m%s\033[00m" \
        "$model" \
        "$context_info" \
        "$worktree" \
        "$branch"
fi
