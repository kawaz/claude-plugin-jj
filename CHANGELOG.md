# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2026-02-24

### Added
- `jj workspace root --name <name>` information to jj-expert agent (workspace path retrieval)
- WorkspaceRef type documentation clarification (path is not available via template)
- Shell snippet for listing all workspace paths

## [0.3.0] - 2026-02-19

### Added
- .gitignore file for common temporary and editor files
- Repository and homepage metadata in plugin.json
- Improved hook error message formatting
- ShellCheck directive for clean static analysis
- marketplace.json for direct repository distribution

### Changed
- Enhanced plugin metadata with license and repository information

## [0.2.1] - 2024

### Added
- jj-guard hook for preventing git command misuse in jj-managed projects
- jj-guide skill with basic concepts and daily operation reference
- jj-expert agent with comprehensive knowledge of revsets, filesets, and templates

### Changed
- Integrated hook, skill, and agent components for cohesive user experience
