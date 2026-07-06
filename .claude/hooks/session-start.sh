#!/bin/bash
set -uo pipefail

# Only relevant for Claude Code on the web: each session runs in a fresh,
# ephemeral container, so anything installed outside the git repo (like
# global skills in ~/.claude/skills) disappears when the container is
# reclaimed. This hook re-provisions that global tooling at the start of
# every session so it doesn't have to be redone by hand each time.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

echo "[session-start] Provisioning global Claude Code skill packages..."

SKILLS_DIR="$HOME/.claude/skills"
LOG_DIR="/tmp/session-start-logs"
mkdir -p "$SKILLS_DIR" "$LOG_DIR"

# 1. vercel-labs/agent-skills (global)
if npx --yes skills add vercel-labs/agent-skills -a claude-code -g -y \
    > "$LOG_DIR/vercel-skills.log" 2>&1; then
  echo "[session-start] vercel-labs/agent-skills OK"
else
  echo "[session-start] WARN: vercel-labs/agent-skills install failed (see $LOG_DIR/vercel-skills.log)"
fi

# 2. obra/superpowers (global)
if npx --yes skills add obra/superpowers -a claude-code -g -y \
    > "$LOG_DIR/superpowers.log" 2>&1; then
  echo "[session-start] obra/superpowers OK"
else
  echo "[session-start] WARN: obra/superpowers install failed (see $LOG_DIR/superpowers.log)"
fi

# 3. pbakaus/impeccable — uses its official installer. If that host is
# blocked by this session's network policy, this step logs a warning and
# skips; it does not attempt any workaround or alternate download path.
# Note: the installer can exit 0 even when its download fails (observed
# "Warning: cannot access install" on a blocked host with exit code 0),
# so success is verified by checking the installed file, not the exit code.
if [ ! -f "$SKILLS_DIR/impeccable/SKILL.md" ]; then
  npx --yes impeccable install --scope=global --providers=claude-code --force \
      > "$LOG_DIR/impeccable-install.log" 2>&1
  if [ -f "$SKILLS_DIR/impeccable/SKILL.md" ]; then
    echo "[session-start] impeccable OK"
  else
    echo "[session-start] WARN: impeccable install failed, possibly network-blocked (see $LOG_DIR/impeccable-install.log)"
  fi
else
  echo "[session-start] impeccable already present, skipping"
fi

# 4. rebelytics/one-skill-to-rule-them-all (task-observer)
mkdir -p "$SKILLS_DIR/task-observer"
if curl -fsSL https://raw.githubusercontent.com/rebelytics/one-skill-to-rule-them-all/main/SKILL.md \
    -o "$SKILLS_DIR/task-observer/SKILL.md" 2> "$LOG_DIR/task-observer.log"; then
  echo "[session-start] task-observer OK"
else
  echo "[session-start] WARN: task-observer download failed (see $LOG_DIR/task-observer.log)"
fi

# 5. thedotmack/claude-mem — install plugin + start background worker
if npx --yes claude-mem install > "$LOG_DIR/claude-mem-install.log" 2>&1; then
  echo "[session-start] claude-mem install OK"
else
  echo "[session-start] WARN: claude-mem install failed (see $LOG_DIR/claude-mem-install.log)"
fi

if ! curl -sf http://localhost:37700/health > /dev/null 2>&1; then
  nohup npx claude-mem start > "$LOG_DIR/claude-mem-worker.log" 2>&1 &
  disown
  echo "[session-start] claude-mem worker started"
else
  echo "[session-start] claude-mem worker already running"
fi

echo "[session-start] Provisioning complete."
