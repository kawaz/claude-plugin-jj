# claude-plugin-jj

[English](README.md) | [日本語](README.ja.md)

A Claude Code plugin that helps users work with jj (Jujutsu VCS) managed projects.

### Design Philosophy

#### 3-Layer Architecture

Hook (Protection) → Skill (Guide) → Agent (Expert) provides progressive support.

| Layer | Component | Role |
|---|---|---|
| Hook | jj-guard | Blocks Git command misuse before execution |
| Skill | jj-guide | Basic knowledge and daily operation reference |
| Agent | jj-expert | Agent with comprehensive advanced knowledge |

#### Benefits of Integrated Plugin

The hook, skill, and agent are designed to work together, enabling each component to rely on the others.

- **jj-guard deny messages are minimal** — Instead of cramming command-specific alternatives into messages, it simply guides users to the skill. This centralizes information and reduces maintenance costs.
- **jj-expert is an agent with more comprehensive jj knowledge** — Provides expert assistance for advanced operations and troubleshooting.

### Components

#### jj-guard Hook (PreToolUse)

Detects and blocks git command execution in jj-managed projects (where `.jj` directory exists). **It's a guard for awareness, not absolute prohibition.**

- Allows jj-mediated git operations like `jj git push`
- On denial, directs users to the skill for specific guidance
- Operations that can only be done with git (submodule, lfs, etc.) can be easily bypassed with `:;git` (intentional design)

#### jj-guide Skill

Provides basic jj concepts, Git→jj mapping table, and daily operation reference. Also serves as knowledge supplement when commands are denied.

#### jj-expert Agent

An agent with more comprehensive jj knowledge. Activated for complex inquiries and troubleshooting.

### Installation

```bash
claude plugin marketplace add kawaz/claude-plugin-jj
claude plugin install jj@claude-plugin-jj
```

### Usage

Once installed, the plugin automatically:
1. Prevents accidental git commands in jj repositories (via jj-guard hook)
2. Provides jj command references when needed (via jj-guide skill)
3. Offers expert assistance for advanced jj operations (via jj-expert agent)

### Troubleshooting

#### When you need to run git commands

If you need to use Git features not yet supported by jj (submodules, lfs, etc.), use the `:;git` prefix:

```bash
:;git submodule update --init
:;git lfs pull
```

#### jj-guide skill not found

You can explicitly invoke the skill in Claude Code by typing `jj:jj-guide`.

### License

MIT
