---
name: refer-web-version
description: Reference the Kurogoma4D/shiro-guessr repository using gh CLI commands. Use when the user mentions "Web版" (Web version), "現行プロジェクト" (current project), or needs to reference existing implementations from the web version of ShiroGuessr. Supports code search, keyword search, and file content retrieval.
---

# Refer Web Version

Reference the web version of ShiroGuessr (`Kurogoma4D/shiro-guessr` repository) using GitHub CLI.

## Repository Information

- **Repository**: `Kurogoma4D/shiro-guessr`
- **Main Branch**: `main`
- **Purpose**: Web version reference for implementation patterns and features

## Search Operations

### Code Search

Search for specific code patterns or implementations:

```bash
gh search code --repo Kurogoma4D/shiro-guessr "search query"
```

**Examples:**

```bash
# Search for map-related code
gh search code --repo Kurogoma4D/shiro-guessr "map"

# Search for API endpoints
gh search code --repo Kurogoma4D/shiro-guessr "api"

# Search for configuration
gh search code --repo Kurogoma4D/shiro-guessr "config"
```

### Keyword Search

Search across the entire repository:

```bash
gh search repos Kurogoma4D/shiro-guessr
```

Or search issues/PRs for context:

```bash
gh search issues --repo Kurogoma4D/shiro-guessr "keyword"
gh search prs --repo Kurogoma4D/shiro-guessr "keyword"
```

### View File Contents

Retrieve specific file contents using the GitHub API:

```bash
gh api repos/Kurogoma4D/shiro-guessr/contents/path/to/file
```

**Note:** The response includes a `content` field with base64-encoded file contents. Decode using:

```bash
gh api repos/Kurogoma4D/shiro-guessr/contents/path/to/file --jq '.content' | base64 -d
```

**Examples:**

```bash
# Get package.json
gh api repos/Kurogoma4D/shiro-guessr/contents/package.json --jq '.content' | base64 -d

# Get a specific component file
gh api repos/Kurogoma4D/shiro-guessr/contents/src/components/Map.tsx --jq '.content' | base64 -d

# List directory contents
gh api repos/Kurogoma4D/shiro-guessr/contents/src
```

**Alternative - Clone and read locally:**

For extensive reading of multiple files, clone the repository:

```bash
gh repo clone Kurogoma4D/shiro-guessr /tmp/shiro-guessr
```

Then use standard Read tool on local files.

## Usage Patterns

**When user asks about Web version implementation:**
1. Identify the feature or component they're asking about
2. Use `gh search code` to find relevant implementations
3. Use `gh api` to retrieve specific file contents if needed
4. Summarize the findings with file paths and line references

**Example conversation:**
- User: "Web版では地図の表示はどうやっているの？" (How is the map displayed in the Web version?)
- Action: `gh search code --repo Kurogoma4D/shiro-guessr "map display"`
- Then: Retrieve relevant file with `gh api repos/Kurogoma4D/shiro-guessr/contents/src/...`

**When comparing Web vs current implementation:**
1. First search the web version using gh commands
2. Then search the local project using Glob/Grep
3. Compare and highlight differences

**Example conversation:**
- User: "現行プロジェクトのconfig設定を見せて" (Show me the config settings in the current project)
- Action: `gh api repos/Kurogoma4D/shiro-guessr/contents/config.json --jq '.content' | base64 -d`

## Tips

- Use `--jq` for JSON parsing and filtering
- Search results may be paginated; check for `next` links
- For binary files, the API returns a download URL instead of base64 content
- Clone the repository locally if reading many files to avoid API rate limits
