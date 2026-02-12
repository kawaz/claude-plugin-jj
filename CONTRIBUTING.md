# Contributing to claude-plugin-jj

Thank you for your interest in contributing to claude-plugin-jj! This plugin helps Claude Code users work effectively with jj (Jujutsu VCS).

## How to Contribute

### Reporting Issues

If you encounter any problems or have suggestions:

1. Check if the issue already exists in [GitHub Issues](https://github.com/kawaz/claude-plugin-jj/issues)
2. Create a new issue with:
   - Clear description of the problem or suggestion
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (Claude Code version, OS, jj version)

### Pull Requests

We welcome pull requests! Please:

1. Fork the repository
2. Create a feature branch
   - Using jj: `jj new -m 'feature/your-feature'`
   - Using git: `git checkout -b feature/your-feature`
3. Make your changes following the guidelines below
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork and submit a pull request

Note: Contributors can use either git or jj for their own workflow. The plugin itself focuses on helping users work with jj.

## Development Guidelines

### Project Structure

```
.
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── hooks/
│   ├── hooks.json          # Hook configuration
│   └── jj-guard.sh         # PreToolUse hook for git command prevention
├── skills/
│   └── jj-guide/
│       └── SKILL.md        # Basic jj concepts and command reference
└── agents/
    └── jj-expert.md        # Expert agent with detailed knowledge
```

### Code Style

#### Bash Scripts
- Use `shellcheck` to validate scripts
- Follow best practices: `set -euo pipefail`
- Add comments for complex logic
- Use meaningful variable names

#### Markdown Documentation
- Use clear, concise language
- Provide examples where helpful
- Keep tables well-formatted
- Use proper heading hierarchy

#### JSON Files
- Validate with `jq` before committing
- Use 2-space indentation
- Keep structure consistent

### Testing

Before submitting a PR:

1. **Validate JSON files:**
   ```bash
   jq . .claude-plugin/plugin.json
   jq . hooks/hooks.json
   ```

2. **Check bash scripts:**
   ```bash
   shellcheck hooks/jj-guard.sh
   ```

3. **Test the hook manually:**
   - Create a test jj repository (`.jj` directory)
   - Verify the hook blocks `git` commands appropriately
   - Verify `:;git` bypass works
   - Verify `jj git push` is allowed

4. **Test documentation:**
   - Verify markdown renders correctly
   - Check all links work
   - Verify code examples are accurate

### Documentation Updates

When updating documentation:

- **skills/jj-guide/SKILL.md**: Keep concise, focused on daily operations
- **agents/jj-expert.md**: Can be comprehensive, include advanced details
- **README.md**: Keep both English and Japanese sections in sync
- **CHANGELOG.md**: Document all notable changes

### Commit Messages

Use clear, descriptive commit messages:

```
Good: Add bookmark conflict resolution guide to jj-expert
Bad: Update docs

Good: Fix jj-guard to allow 'jj git fetch'
Bad: Fix bug
```

### Language

- **README.md**: Bilingual (English and Japanese)
- **SKILL.md and jj-expert.md**: Japanese (primary audience)
- **Code comments**: Japanese preferred for consistency
- **Commit messages**: English

## Plugin Design Principles

1. **3-Layer Architecture**: Hook → Skill → Agent
   - Each layer has a specific purpose
   - Components reference each other to avoid duplication

2. **Minimal Hook Messages**: 
   - jj-guard provides brief denial reasons
   - Detailed guidance delegated to jj-guide skill

3. **Progressive Knowledge**:
   - Skill covers basics and daily operations
   - Agent provides deep expertise for complex scenarios

4. **Soft Enforcement**:
   - Hook is for awareness, not absolute prevention
   - Bypass mechanisms (`:;git`) are intentional

## Questions?

Feel free to open an issue for questions or discussion!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
