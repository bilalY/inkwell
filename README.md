# Inkwell

A menu-driven Windows batch tool for managing Etsy digital product workflows — create, track, check, and package.

## Features

- **Create New Product** — folder scaffold with auto-numbering (PLN-001, JRN-002), category subfolders, and template files (listing, tasks, notes, license)
- **My Products** — dashboard showing all products with progress bars
- **Open Product Folder** — quick-open any product in Explorer
- **Pre-Listing Check** — 5-point readiness check before uploading to Etsy
- **Package for Etsy** — zip your export files into a single download for buyers
- **Brand Kit** — shared colours, fonts, and design guidelines across all products

## Usage

1. Put `inkwell.bat` in your "Etsy Products" folder
2. Double-click it
3. Pick from the menu

## Product Types

| Type | Prefix | Folder |
|------|--------|--------|
| Planner | PLN | Planners/ |
| Journal | JRN | Journals/ |
| Printable | PRT | Printables/ |
| Workbook | WBK | Workbooks/ |

## Tech Stack

- Windows Batch (.bat) with ANSI colour output
- PowerShell `Compress-Archive` for zipping (ships with Windows 10+)
- Zero external dependencies

Created: 2026-04-12
