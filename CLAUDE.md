# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a **comprehensive skills library** for Claude AI and Claude Code — reusable, production-ready skill packages that bundle domain expertise, best practices, analysis tools, and strategic frameworks. The repository provides modular skills that teams can download and use directly in their workflows.

**Current Scope:** 171 production-ready skills across 9 domains with 240 Python automation tools, 14 agents, 14 slash commands, and a MkDocs Material documentation site.

**Key Distinction**: This is NOT a traditional application. It's a library of skill packages meant to be extracted and deployed by users into their own Claude workflows.

**Multi-Platform:** Compatible with Claude Code, OpenAI Codex CLI (`.codex/`), Gemini CLI (`.gemini/`), and OpenClaw.

## Navigation Map

This repository uses **modular documentation**. For domain-specific guidance, see:

| Domain | CLAUDE.md Location | Focus |
|--------|-------------------|-------|
| **Agent Development** | [agents/CLAUDE.md](agents/CLAUDE.md) | cs-* agent creation, YAML frontmatter, relative paths |
| **Marketing Skills** | [marketing-skill/CLAUDE.md](marketing-skill/CLAUDE.md) | Content creation, SEO, ASO, demand gen, campaign analytics |
| **Product Team** | [product-team/CLAUDE.md](product-team/CLAUDE.md) | RICE, OKRs, user stories, UX research, SaaS scaffolding |
| **Engineering (Core)** | [engineering-team/CLAUDE.md](engineering-team/CLAUDE.md) | Fullstack, AI/ML, DevOps, security, data, QA tools |
| **Engineering (POWERFUL)** | [engineering/](engineering/) | Agent design, RAG, MCP, CI/CD, database, observability |
| **C-Level Advisory** | [c-level-advisor/CLAUDE.md](c-level-advisor/CLAUDE.md) | CEO/CTO/CFO/CMO/COO/CPO/CRO/CISO/CHRO strategic decision-making |
| **Project Management** | [project-management/CLAUDE.md](project-management/CLAUDE.md) | Atlassian MCP, Jira/Confluence integration |
| **RA/QM Compliance** | [ra-qm-team/CLAUDE.md](ra-qm-team/CLAUDE.md) | ISO 13485, MDR, FDA, GDPR, ISO 27001 compliance |
| **Business & Growth** | [business-growth/CLAUDE.md](business-growth/CLAUDE.md) | Customer success, sales engineering, revenue operations |
| **Finance** | [finance/CLAUDE.md](finance/CLAUDE.md) | Financial analysis, DCF valuation, budgeting, forecasting, SaaS metrics |
| **Standards Library** | [standards/CLAUDE.md](standards/CLAUDE.md) | Communication, quality, git, security standards |
| **Templates** | [templates/CLAUDE.md](templates/CLAUDE.md) | Template system usage |

## Architecture Overview

### Repository Structure

```
production-ready-claude-skills/
├── .claude/                   # Claude Code local config
│   └── commands/              # Local slash commands (README, git, review, security-scan)
├── .claude-plugin/            # Plugin registry (marketplace.json) — 19 marketplace plugins
├── .codex/                    # OpenAI Codex CLI support
│   └── skills/                # Codex skill indexes
├── .gemini/                   # Gemini CLI support
│   └── skills/                # Gemini skill indexes
├── .github/                   # GitHub Actions CI/CD (9 workflows)
│   ├── workflows/
│   │   ├── ci-quality-gate.yml        # Lint, syntax, security, link checks on PRs
│   │   ├── claude-code-review.yml     # Automated Claude code review
│   │   ├── enforce-pr-target.yml      # Enforces dev as PR base
│   │   ├── pr-issue-auto-close.yml    # Auto-close linked issues on merge
│   │   ├── skill-security-audit.yml   # Security scan on skill changes
│   │   ├── smart-sync.yml             # Kanban board sync
│   │   ├── static.yml                 # GitHub Pages (MkDocs)
│   │   ├── sync-codex-skills.yml      # Codex symlink sync
│   │   └── virustotal-scan.yml        # Malware scan on uploads
│   └── ISSUE_TEMPLATE/
├── agents/                    # 14 cs-* prefixed agents across all domains
│   ├── business-growth/       # cs-growth-strategist
│   ├── c-level/               # cs-ceo-advisor, cs-cto-advisor
│   ├── engineering/           # cs-senior-engineer
│   ├── engineering-team/      # cs-engineering-lead
│   ├── finance/               # cs-financial-analyst
│   ├── marketing/             # cs-content-creator, cs-demand-gen-specialist
│   ├── product/               # cs-agile-product-owner, cs-product-manager, cs-product-strategist, cs-ux-researcher
│   ├── project-management/    # cs-project-manager
│   └── ra-qm-team/            # cs-quality-regulatory
├── commands/                  # 14 slash commands (changelog, tdd, saas-health, rice, tech-debt, etc.)
├── engineering-team/          # 23+ core engineering skills + Playwright Pro + Self-Improving Agent
├── engineering/               # 25 POWERFUL-tier advanced engineering skills
├── product-team/              # 8 product skills + Python tools
├── marketing-skill/           # 42 marketing skills (7 pods) + Python tools
├── c-level-advisor/           # 28 C-level advisory skills (10 roles + orchestration)
├── project-management/        # 6 PM skills + Atlassian MCP
├── ra-qm-team/                # 12 RA/QM compliance skills
├── business-growth/           # 4 business & growth skills + Python tools
├── finance/                   # 2 finance skills (financial-analyst, saas-metrics-coach)
├── eval-workspace/            # Skill evaluation results (Tessl)
├── standards/                 # Standards library (communication, quality, git, documentation, security)
├── templates/                 # Reusable templates
├── docs/                      # MkDocs Material documentation site source
├── scripts/                   # Build scripts (generate-docs.py for MkDocs)
├── documentation/             # Implementation plans, sprints, delivery
├── SKILL-AUTHORING-STANDARD.md  # Canonical skill creation spec
└── SKILL_PIPELINE.md          # Mandatory 9-phase production pipeline
```

### Skill Package Pattern

Every skill follows this standard structure:
```
skill-name/
├── SKILL.md              # Master documentation (≤10KB / ≤500 lines)
├── scripts/              # Python CLI tools (stdlib-only, no ML/LLM calls)
├── references/           # Expert knowledge bases (loaded on demand)
├── assets/ or templates/ # User-fillable templates
└── evals/
    └── evals.json        # Test cases + assertions (2-3+ per skill)
```

**Design Philosophy**: Skills are self-contained packages. Each includes executable tools (Python scripts), knowledge bases (markdown references), and user-facing templates. Teams can extract a skill folder and use it immediately.

**Knowledge flow**: `references/` → `SKILL.md` workflows → executed via `scripts/` → applied using `assets/`

## Skill Authoring Standard

See [`SKILL-AUTHORING-STANDARD.md`](SKILL-AUTHORING-STANDARD.md) for the full spec. Key rules:

### SKILL.md Requirements
- **YAML frontmatter required** — `name` (kebab-case) and `description` (trigger-phrase-rich)
- **Practitioner voice** — "You are an expert in X. Your goal is Y."
- **Context-first** — check domain context file before asking questions
- **Multi-mode** — minimum 2 workflows (build-from-scratch + optimize-existing)
- **≤500 lines** — overflow goes into `references/` with clear pointers
- **Proactive Triggers** — 4-6 conditions where skill surfaces issues unprompted
- **Output Artifacts table** — 4-6 deliverables with explicit formats

### Python Script Rules
- **stdlib-only** — zero external dependencies (exception: `pip install <one package>` if documented in SKILL.md)
- **CLI-first** — `python tool.py [args]` with `--help` flag
- **JSON output** — structured output for programmatic use + human-readable summary
- **Sample data embedded** — runs with zero config for demo/testing
- **Scoring tools use 0-100 scale** — consistent across all tools
- **Naming:** `snake_case_verb_noun.py` (e.g., `seo_checker.py`, `churn_risk_scorer.py`)

### Domain Context Files

Each domain uses a context file that skills read before asking questions:

| Domain | Context File |
|--------|-------------|
| C-Suite | `company-context.md` |
| Marketing | `marketing-context.md` |
| Engineering | `project-context.md` |
| Product | `product-context.md` |
| RA/QM | `regulatory-context.md` |

## Mandatory Production Pipeline

See [`SKILL_PIPELINE.md`](SKILL_PIPELINE.md) for the full spec. Every skill MUST go through all 9 phases:

```
Intent → Research → Draft → Eval → Iterate → Compliance → Package → Deploy → Verify → Rollback-Ready
```

### Quality Gate (blocks merge)
- Tessl score ≥85% (or manual 8-point compliance check if unavailable)
- Baseline delta ≥+30% on key assertions
- 8-point Claude Code compliance check passed
- All file references resolve
- YAML frontmatter valid

### Quality Tiers

| Tier | Score | Criteria |
|------|-------|----------|
| **POWERFUL** ⭐ | ≥85% | Expert-level, scripts, refs, evals pass, real-world utility |
| **SOLID** | 70–84% | Good knowledge, some automation, useful |
| **GENERIC** | 55–69% | Too general, needs domain depth |
| **WEAK** | <55% | Reject or complete rewrite |

**We only ship POWERFUL. Everything else goes back to iteration.**

## Agent Architecture

Agents (`agents/domain/cs-*.md`) **orchestrate** skills — they don't replace them. Skills remain self-contained and portable.

### Agent YAML Frontmatter (required)
```yaml
---
name: cs-agent-name
description: One-line description of what this agent does
skills: skill-folder-name
domain: domain-name
model: sonnet
tools: [Read, Write, Bash, Grep, Glob]
---
```

### Path Resolution
All skill references from agents use the `../../` pattern:
```
agents/marketing/cs-content-creator.md
  → ../../marketing-skill/content-creator/scripts/tool.py
```

### Current Agents (14 total)

| Agent | Domain | Key Skills Used |
|-------|--------|----------------|
| cs-growth-strategist | Business Growth | customer-success-manager, revenue-operations |
| cs-ceo-advisor | C-Level | ceo-advisor |
| cs-cto-advisor | C-Level | cto-advisor |
| cs-senior-engineer | Engineering POWERFUL | agent-designer, rag-architect, mcp-server-builder |
| cs-engineering-lead | Engineering Core | senior-architect, senior-fullstack, senior-devops |
| cs-financial-analyst | Finance | financial-analyst, saas-metrics-coach |
| cs-content-creator | Marketing | content-creator |
| cs-demand-gen-specialist | Marketing | marketing-demand-acquisition |
| cs-agile-product-owner | Product | agile-product-owner |
| cs-product-manager | Product | product-manager-toolkit |
| cs-product-strategist | Product | product-strategist |
| cs-ux-researcher | Product | ux-researcher-designer |
| cs-project-manager | PM | senior-pm, scrum-master, jira-expert |
| cs-quality-regulatory | RA/QM | regulatory-affairs-head, quality-manager-qms-iso13485 |

## Slash Commands (14 total)

Located in `commands/`. Available in Claude Code via `/command-name`:

| Command | Purpose |
|---------|---------|
| `/changelog` | Generate structured CHANGELOG entries |
| `/competitive-matrix` | Build competitor comparison matrices |
| `/financial-health` | Run financial health diagnostics |
| `/okr` | Generate OKR cascades |
| `/persona` | Create user personas |
| `/pipeline` | Visualize delivery pipelines |
| `/project-health` | Project status diagnostics |
| `/retro` | Sprint retrospective templates |
| `/rice` | RICE prioritization framework |
| `/saas-health` | SaaS metrics health check |
| `/sprint-health` | Sprint velocity and health |
| `/tdd` | Test-driven development guidance |
| `/tech-debt` | Technical debt tracking |
| `/user-story` | User story generation |

## Git Workflow

**Branch Strategy:** feature → dev → main (PR only)

**Branch Protection Active:** Main branch requires PR approval. Direct pushes blocked.

```bash
# 1. Always start from dev
git checkout dev
git pull origin dev

# 2. Create feature branch
git checkout -b feature/domain-{name}

# 3. Work and commit (conventional commits)
feat(agents): implement cs-{agent-name}
fix(tool): correct calculation logic
docs(workflow): update branch strategy

# 4. Push and create PR to dev
git push -u origin feature/domain-{name}
# gh pr create --base dev --head feature/domain-{name}

# 5. After approval, PR merges to dev
# 6. Periodically, dev merges to main via PR
```

**Branch Protection Rules:**
- ✅ Main: Requires PR approval, no direct push
- ✅ Dev: Unprotected, PRs recommended
- ✅ All: Conventional commits enforced
- ✅ CI quality gate must pass before merge

**Conventional Commit Scopes:**
- `feat(agents):`, `feat(marketing):`, `feat(engineering):`, `feat(product):`
- `fix(tool):`, `fix(scripts):`, `fix(ci):`
- `docs(workflow):`, `docs(skill):`
- `chore(sync):`, `chore(marketplace):`

See [documentation/WORKFLOW.md](documentation/WORKFLOW.md) and [standards/git/git-workflow-standards.md](standards/git/git-workflow-standards.md).

## CI/CD Pipelines

Nine GitHub Actions workflows run automatically:

| Workflow | Trigger | What It Checks |
|----------|---------|----------------|
| `ci-quality-gate.yml` | PR open/sync | YAML lint, Python syntax, safety audit, markdown links |
| `claude-code-review.yml` | PR open | Automated Claude code review |
| `enforce-pr-target.yml` | PR open | Ensures PRs target `dev`, not `main` |
| `skill-security-audit.yml` | PR with skill changes | Runs skill-security-auditor on changed skills |
| `virustotal-scan.yml` | File uploads | Malware scan |
| `static.yml` | Push to main | Deploys MkDocs to GitHub Pages |
| `sync-codex-skills.yml` | Push | Syncs Codex skill symlinks |
| `smart-sync.yml` | Issue/PR events | Kanban board sync |
| `pr-issue-auto-close.yml` | PR merge | Closes linked issues |

## Documentation Site

MkDocs Material site at `https://alirezarezvani.github.io/claude-skills` (206+ indexed pages).

**To regenerate docs:**
```bash
python scripts/generate-docs.py
# Then: mkdocs build  OR  mkdocs serve (local preview)
```

Docs are auto-deployed to GitHub Pages via `static.yml` on every push to main.

## Multi-Platform Support

| Platform | Config Location | Activation |
|----------|----------------|-----------|
| Claude Code | `.claude/commands/` + `SKILL.md` | `/plugin install <skill>` |
| OpenAI Codex | `.codex/skills/` | `codex skill activate <name>` |
| Gemini CLI | `.gemini/skills/` | `activate_skill(name="<name>")` |
| OpenClaw | `.claude-plugin/marketplace.json` | Marketplace install |

**After adding a skill**, sync all platforms:
```bash
# Codex sync is automated via CI (sync-codex-skills.yml)
# Gemini sync:
./scripts/gemini-install.sh
# Marketplace: update .claude-plugin/marketplace.json
```

## Development Environment

**No build system or test frameworks** — intentional design for portability.

**Python Requirements:**
- Python 3.10+ (CI uses 3.11)
- Standard library only in scripts
- If external deps needed: document in SKILL.md, use `pip install <package>`

**Local Quality Checks:**
```bash
# Run before pushing
/review          # Local quality gate
/security-scan   # Security validation
```

**CI installs:** `yamllint`, `check-jsonschema`, `safety` (Python dep audit)

## Plugin Registry

`marketplace.json` at `.claude-plugin/marketplace.json` registers 19 marketplace plugins:
- Each domain folder is a plugin (marketing-skills, c-level-skills, engineering-advanced-skills, etc.)
- Users install via `/plugin install <plugin-name>`
- Update counts and descriptions when adding skills

## Versioning

| Change Type | Bump | Example |
|-------------|------|---------|
| Existing skill improvement (Tessl, trigger fixes, content trim) | Patch | 2.1.2 → 2.1.3 |
| New skills, scripts, agents, commands | Minor | 2.1.x → 2.2.0 |
| Breaking changes (restructure, removed skills, API) | Major | 2.x → 3.0.0 |

## Current Version

**Version:** v2.1.2 (latest released) | Unreleased work in progress

**v2.1.2 (2026-03-10):**
- Landing page generator outputs Next.js TSX + Tailwind CSS by default (4 design styles, 7 section generators)
- Brand voice integration in landing page workflow
- 237/237 Python scripts verified passing `--help`
- Competitive teardown SKILL.md: 6 broken file references fixed

**In Progress (unreleased):**
- `skill-security-auditor` (POWERFUL tier) — scans for malicious code, prompt injection, supply chain risks
- `git-worktree-manager` enhancements — `worktree_manager.py`, `worktree_cleanup.py`
- `mcp-server-builder` enhancements — `openapi_to_mcp.py`, `mcp_validator.py`
- `changelog-generator` enhancements — `generate_changelog.py`, `commit_linter.py`
- `ci-cd-pipeline-builder` enhancements — `stack_detector.py`, `pipeline_generator.py`
- `saas-metrics-coach` integrated into finance domain

**Past versions:** See [CHANGELOG.md](CHANGELOG.md) for full history.

## Key Principles

1. **Skills are products** — Each skill deployable as a standalone package
2. **Documentation-driven** — Success depends on clear, actionable docs
3. **Algorithm over AI** — Deterministic analysis (Python scripts) not LLM calls
4. **Template-heavy** — Ready-to-use templates users customize
5. **Platform-specific** — Specific best practices > generic advice
6. **POWERFUL only** — Only ship skills scoring ≥85% quality (Tessl)

## Anti-Patterns to Avoid

- Creating cross-skill dependencies (keep each self-contained)
- Adding complex build systems or test frameworks
- Generic advice without specific frameworks or data
- LLM calls inside Python scripts (defeats portability and speed)
- Pushing directly to main (branch protection enforced)
- SKILL.md over 500 lines (move content to references/)
- Missing YAML frontmatter on SKILL.md files
- Broken file references (CI checks these)

## Integration Checklist (New Skill)

When adding a new skill, complete ALL of the following:

### Required (blocks merge)
- [ ] SKILL.md: YAML frontmatter, practitioner voice, ≤500 lines
- [ ] SKILL.md: Description includes trigger phrases and edge cases
- [ ] scripts/: Python tools (stdlib-only, `--help` works)
- [ ] references/: Expert knowledge bases
- [ ] evals/evals.json: 2-3+ test cases with assertions
- [ ] Tessl score ≥85% (or manual 8-point compliance)
- [ ] plugin.json in skill folder (strict format)
- [ ] `.claude-plugin/marketplace.json` updated
- [ ] CHANGELOG.md updated with `### Added`
- [ ] PR targets `dev` branch

### Recommended
- [ ] Agent: `agents/domain/cs-<role>.md` defined
- [ ] Command: `commands/<action>.md` defined
- [ ] `.codex/skills/` index updated (auto-synced by CI)
- [ ] `.gemini/skills/` index updated (`./scripts/gemini-install.sh`)
- [ ] Domain CLAUDE.md updated
- [ ] Domain README.md updated
- [ ] `docs/` regenerated (`python scripts/generate-docs.py`)

## Additional Resources

- **Plugin Registry:** [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)
- **Skill Standard:** [SKILL-AUTHORING-STANDARD.md](SKILL-AUTHORING-STANDARD.md)
- **Production Pipeline:** [SKILL_PIPELINE.md](SKILL_PIPELINE.md)
- **Standards Library:** [standards/](standards/) — communication, quality, git, documentation, security
- **Implementation Plans:** [documentation/implementation/](documentation/implementation/)
- **Sprint Delivery:** [documentation/delivery/](documentation/delivery/)
- **Docs Site:** https://alirezarezvani.github.io/claude-skills

---

**Last Updated:** June 26, 2026
**Version:** v2.1.2 (released) | unreleased improvements in progress
**Status:** 171 skills across 9 domains, 14 agents, 14 commands, 240 Python tools, 19 marketplace plugins, docs site live
