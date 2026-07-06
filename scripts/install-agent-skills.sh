#!/bin/bash
#
# Portable Agent Skills Installer
#
# Installs 5 external Claude Code skill packages globally (~/.claude/skills/),
# so they're available in ANY Claude Code session or machine you run this on —
# not just this repo. Safe to copy standalone or run via curl | bash elsewhere.
#
# Packages installed:
#   - vercel-labs/agent-skills  (9 skills: Vercel/React/Next.js best practices)
#   - obra/superpowers          (14 skills: brainstorming, TDD, code review, etc.)
#   - pbakaus/impeccable        (UI design guidance, 23 commands)
#   - rebelytics/one-skill-to-rule-them-all (task-observer meta-skill)
#   - thedotmack/claude-mem     (persistent cross-session memory + worker)
#
# Usage:
#   ./scripts/install-agent-skills.sh
#   curl -fsSL <raw-url-to-this-file> | bash
#
# Idempotent: safe to re-run. Each step logs a warning and continues on
# failure rather than aborting the whole install.
#

set -uo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo ""
echo "========================================"
echo "  Portable Agent Skills Installer"
echo "========================================"
echo ""

if ! command -v npx &> /dev/null; then
  print_warn "npx not found — install Node.js (https://nodejs.org) first."
  exit 1
fi

SKILLS_DIR="$HOME/.claude/skills"
LOG_DIR="$(mktemp -d)"
mkdir -p "$SKILLS_DIR"
print_info "Installing to: $SKILLS_DIR"
print_info "Logs: $LOG_DIR"
echo ""

# 1. vercel-labs/agent-skills (global)
print_info "Installing vercel-labs/agent-skills..."
if npx --yes skills add vercel-labs/agent-skills -a claude-code -g -y \
    > "$LOG_DIR/vercel-skills.log" 2>&1; then
  print_success "vercel-labs/agent-skills (9 skills)"
else
  print_warn "vercel-labs/agent-skills failed — see $LOG_DIR/vercel-skills.log"
fi

# 2. obra/superpowers (global)
print_info "Installing obra/superpowers..."
if npx --yes skills add obra/superpowers -a claude-code -g -y \
    > "$LOG_DIR/superpowers.log" 2>&1; then
  print_success "obra/superpowers (14 skills)"
else
  print_warn "obra/superpowers failed — see $LOG_DIR/superpowers.log"
fi

# 3. pbakaus/impeccable — official installer only. If its download host is
# unreachable from this machine/session, this step warns and skips; it does
# not fall back to any alternate download path.
print_info "Installing pbakaus/impeccable..."
if [ -f "$SKILLS_DIR/impeccable/SKILL.md" ]; then
  print_success "impeccable (already installed)"
else
  npx --yes impeccable install --scope=global --providers=claude-code --force \
      > "$LOG_DIR/impeccable-install.log" 2>&1
  if [ -f "$SKILLS_DIR/impeccable/SKILL.md" ]; then
    print_success "impeccable"
  else
    print_warn "impeccable failed (its installer can exit 0 on failure, so this checks the installed file, not the exit code) — see $LOG_DIR/impeccable-install.log"
  fi
fi

# 4. rebelytics/one-skill-to-rule-them-all (task-observer)
print_info "Installing task-observer (one-skill-to-rule-them-all)..."
mkdir -p "$SKILLS_DIR/task-observer"
if curl -fsSL https://raw.githubusercontent.com/rebelytics/one-skill-to-rule-them-all/main/SKILL.md \
    -o "$SKILLS_DIR/task-observer/SKILL.md" 2> "$LOG_DIR/task-observer.log"; then
  print_success "task-observer"
else
  print_warn "task-observer failed — see $LOG_DIR/task-observer.log"
fi

# 5. thedotmack/claude-mem — install plugin + start background worker
print_info "Installing claude-mem..."
if npx --yes claude-mem install > "$LOG_DIR/claude-mem-install.log" 2>&1; then
  print_success "claude-mem installed"
else
  print_warn "claude-mem install failed — see $LOG_DIR/claude-mem-install.log"
fi

if curl -sf http://localhost:37700/health > /dev/null 2>&1; then
  print_success "claude-mem worker already running"
else
  nohup npx claude-mem start > "$LOG_DIR/claude-mem-worker.log" 2>&1 &
  disown
  print_success "claude-mem worker started"
fi

echo ""
echo "========================================"
print_success "Done. Restart your Claude Code session to discover the new skills."
echo "========================================"
echo ""
