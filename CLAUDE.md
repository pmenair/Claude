# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal legal practice management system for a Georgia tort litigation attorney, built entirely around Emacs and Org-mode workflows. The codebase serves as a comprehensive case management and documentation system rather than a traditional software application.

## Architecture

### Core Components

- **Case Database** (`WORK SYNC/projects/1-data/database.org`) - Main case tracking in Org-mode format
- **Denote Case Files** (`WORK SYNC/projects/6-denote/`) - Individual timestamped case files using format `YYYYMMDDTHHMMSS--name__casenotes.org`
- **Legal Document Templates** (`WORK SYNC/projects/old/1-data-bak/code/z-lawtex/`) - LaTeX classes for legal documents
- **Emacs Configuration** (`WORK SYNC/Config/init.el`) - Primary editor configuration for legal practice

### File Naming Conventions

- **Denote files**: `YYYYMMDDTHHMMSS--subject__tags.ext`
- **Case notes**: Always tagged with `__casenotes`
- **Research files**: Tagged with `__research`
- **Archive structure**: Multiple levels (`old/`, `zArchive-1/`, `bak/`)

## Technology Stack

- **Emacs Lisp** - Core configuration and automation
- **Org-mode** - Primary data format for case management and note-taking
- **LaTeX** - Professional legal document generation with custom classes (`lawbrief.cls`, `lawmemo.cls`)
- **HTML/CSS** - Export capabilities for web-based case status reporting
- **Denote** - Structured note-taking system with unique identifiers

## Development Workflows

### Case Management

1. **New case intake**: Create denote file in `6-denote/` directory
2. **Case tracking**: Update main database at `1-data/database.org`
3. **Document generation**: Use LaTeX templates from `z-lawtex/` directory
4. **Status reporting**: Export Org files to HTML using custom CSS

### Document Generation

- **Legal briefs**: Use `lawbrief.cls` LaTeX class with Bluebook citation style
- **Motions**: Templates available in `z-lawtex/2-motion/`
- **Status reports**: Export to HTML with `print-style.css` for professional formatting

### Data Organization

- **Active cases**: Maintained in `database.org` with structured properties
- **Archived cases**: Moved to timestamped archive directories
- **Backup strategy**: Multiple backup levels with `.org_archive` files

## Key File Locations

- **Main case database**: `WORK SYNC/projects/1-data/database.org`
- **Emacs config**: `WORK SYNC/Config/init.el`
- **LaTeX templates**: `WORK SYNC/projects/old/1-data-bak/code/z-lawtex/`
- **CSS styling**: `WORK SYNC/projects/1-data/css/print-style.css`
- **Active case notes**: `WORK SYNC/projects/6-denote/`

## Important Notes

- This is **not a traditional software project** - no package.json, Makefile, or conventional build system
- All development tools are integrated into the Emacs environment
- File modifications should preserve Org-mode structure and Denote naming conventions
- LaTeX compilation is handled through Emacs packages, not external build scripts
- The system prioritizes data integrity and legal document formatting standards over typical software development practices