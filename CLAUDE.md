# CLAUDE.md — Inkwell

> **Description:** A menu-driven Windows batch tool for managing Etsy digital product workflows — create, track, check, and package.
> **Status:** Active

---

## Critical Rules

- Pure `.bat` except for one PowerShell exception: `Compress-Archive` for zipping (ships with Windows 10+)
- Handle spaces in product names correctly — always quote paths
- Keep the script self-contained — no external dependencies beyond the OS
- All UI screens must clear and redraw the banner — no scrolling history

---

## What (Project Overview)

### Description

Inkwell is a menu-driven batch tool that helps an Etsy seller manage digital product workflows. It handles folder scaffolding, progress tracking, pre-listing checks, and packaging files for upload. Designed for a non-technical user who creates planners, journals, printables, and workbooks in Adobe Illustrator.

### Features

| Feature | Description |
|---------|-------------|
| Create New Product | Folder scaffold with auto-numbering (PLN-001, JRN-002), category subfolders, template files |
| My Products | Dashboard showing all products with progress bars from tasks.md |
| Open Product Folder | Quick-open any product in Windows Explorer |
| Pre-Listing Check | 5-point readiness check (exports, mockups, listing, license, tasks) |
| Package for Etsy | Zip Exports/ folder contents for Etsy upload, with 20MB warning |
| Brand Kit | Shared `_brand-kit.md` with colours, fonts, design guidelines |

### Tech Stack

| Layer | Technology |
|-------|------------|
| Script | Windows Batch (.bat) |
| Platform | Windows 10/11 |
| Zip | PowerShell `Compress-Archive` (one-liner, ships with OS) |
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

- **Product type** — category of digital product (planner, journal, printable, workbook)
- **Scaffold** — folder structure and template files created for each new product
- **Listing** — Etsy listing copy, tags, and description (listing.md)
- **Brand kit** — shared colours, fonts, and design guidelines (`_brand-kit.md`)
- **Pre-listing check** — 5-point readiness validation before Etsy upload
- **Package** — zipping Exports/ contents for Etsy digital delivery

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

- [ ] All 6 menu options work correctly
- [ ] Create: all 4 product types generate correct files
- [ ] Create: spaces in names handled, skip name works
- [ ] Dashboard: shows progress bars per product
- [ ] Pre-listing check: shows PASS/FAIL for all 5 checks
- [ ] Package: zips Exports/, warns if > 20MB
- [ ] Brand kit created on first run
- [ ] All screens have consistent banner and colours
- [ ] ANSI colours render on Windows 10+

---

## Conventions

### Code Style

- `@echo off` + `setlocal enabledelayedexpansion` at top
- Comment sections with `REM ===` block headers
- Meaningful variable names (not single letters)
- Quote all paths: `"!PRODUCT_PATH!\Subfolder"`
- Subroutines end with `goto :eof`
- Screen-based UI: every action does `cls` + `:DrawHeader`

### Git

- Branch strategy: `main` only
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
