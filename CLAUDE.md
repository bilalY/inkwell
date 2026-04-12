# CLAUDE.md — Inkwell

> **Description:** A Windows batch script that scaffolds folder structures for new Etsy digital product designs.
> **Status:** Active

---

## Critical Rules

- Never assume PowerShell — this must be a pure `.bat` file that works on any Windows machine
- Handle spaces in product names correctly — always quote paths
- Keep the script self-contained — no external dependencies

---

## What (Project Overview)

### Description

Inkwell is a batch script that helps an Etsy seller set up consistent folder structures when starting a new digital product design (planners, journals, printables). The user double-clicks the script, answers a few prompts, and gets a ready-to-use project folder.

### Tech Stack

| Layer | Technology |
|-------|------------|
| Script | Windows Batch (.bat) |
| Platform | Windows 10/11 |
| Dependencies | None |

### Project Locations

| Location | Purpose |
|----------|---------|
| `Personal/Projects/inkwell/` | Vault — planning, specs, sessions |
| `~/repos/inkwell/` | Code — Claude Code works here |

### GitHub

| Resource | Value |
|----------|-------|
| Repo | `bilalY/inkwell` |

### Key Documents

| Document | Location | Purpose |
|----------|----------|---------|
| Coding Standards | `Docs/Coding Standards.md` (vault) | Batch scripting conventions |

---

## Domain (Key Concepts)

- **Product type** — the category of digital product (planner, journal, printable, custom)
- **Scaffold** — the folder structure and template files created for each new product
- **Listing** — the Etsy listing copy, tags, and description for a product

---

## Validation (How to Verify Work)

### Commands

```bash
# Test on Linux (syntax check only — logic testing needs Windows)
dos2unix inkwell.bat && bash -n inkwell.bat 2>&1 || echo "Not bash-compatible (expected for .bat)"

# Test on Windows (the real test)
# Double-click inkwell.bat or run from cmd: inkwell.bat
```

### Definition of Done

Every piece of work must satisfy ALL of these before it's complete:

- [ ] Script runs without errors on Windows
- [ ] Folder structure is created correctly
- [ ] Spaces in product names handled
- [ ] Template files are created with useful content
- [ ] User prompts are clear and friendly

---

## Conventions

### Code Style

- Use `@echo off` at the top of every script
- Use `setlocal enabledelayedexpansion` when needed for variable expansion
- Comment sections with `REM ===` block headers
- Use meaningful variable names (not single letters)
- Quote all paths that could contain spaces: `"%PRODUCT_NAME%"`

### Git

- Branch strategy: `main` only — this is a simple script, no `dev` branch needed
- Commit format: Conventional Commits (`feat:`, `fix:`, `docs:`)

---

## Vault Structure

```
inkwell/
├── CLAUDE.md                  # This file
├── inkwell.md                 # Project dashboard
├── _scratchpad.md             # Quick notes for sharing with Claude
│
├── Docs/                      # Technical documentation
│   └── Coding Standards.md   # Batch scripting conventions
├── Learning/                  # Concept notes from this project
│   ├── Concepts Log.md       # Auto-aggregated from session logs (DataviewJS)
│   └── Learning Roadmap.md   # Concepts to learn from this project
├── Sessions/                  # Session logs (YYYY-MM-DD-NN-title.md)
├── Reviews/                   # Deep review reports
├── Testing/                   # Testing guides
```
