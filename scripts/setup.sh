#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# second-brain-os setup script
# =============================================================================
# Installs MemPalace, scaffolds your vault, and configures CLAUDE.md + skills.
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${BLUE}[info]${NC} $*"; }
success() { echo -e "${GREEN}[done]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC} $*"; }
error()   { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }

echo ""
echo "======================================"
echo "  second-brain-os setup"
echo "======================================"
echo ""

# ── Collect config ─────────────────────────────────────────────────────────

read -rp "Your name: " YOUR_NAME
read -rp "Vault path (default: ~/second-brain): " VAULT_PATH
VAULT_PATH="${VAULT_PATH:-$HOME/second-brain}"
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"

read -rp "Jira org (e.g. yourcompany.atlassian.net, or 'skip'): " JIRA_ORG
JIRA_ORG="${JIRA_ORG:-skip}"

read -rp "Jira project key (e.g. ENG, or 'skip'): " JIRA_PROJECT
JIRA_PROJECT="${JIRA_PROJECT:-TICKET}"

read -rp "GitHub username (or 'skip'): " GITHUB_USER
GITHUB_USER="${GITHUB_USER:-your-username}"

echo ""
info "Configuration:"
echo "  Name:          $YOUR_NAME"
echo "  Vault path:    $VAULT_PATH"
echo "  Jira org:      $JIRA_ORG"
echo "  Jira project:  $JIRA_PROJECT"
echo "  GitHub user:   $GITHUB_USER"
echo ""
read -rp "Proceed? [y/N] " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { info "Aborted."; exit 0; }

# ── 1. Install uv (if missing) ──────────────────────────────────────────────

info "Checking uv..."
if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    success "uv installed"
else
    success "uv already installed ($(uv --version))"
fi

# ── 2. Install MemPalace ────────────────────────────────────────────────────

info "Installing MemPalace..."
if uv tool install mempalace 2>&1 | grep -q "already installed"; then
    success "MemPalace already installed"
else
    success "MemPalace installed"
fi

# ── 3. Initialize MemPalace palace ─────────────────────────────────────────

PALACE_DIR="$HOME/.mempalace/palace"
if [[ -d "$PALACE_DIR" ]]; then
    success "MemPalace palace already exists at $PALACE_DIR"
else
    info "Initializing MemPalace palace..."
    mempalace init "$VAULT_PATH" 2>/dev/null || true
    success "MemPalace palace initialized"
fi

# ── 4. Scaffold vault ───────────────────────────────────────────────────────

info "Scaffolding vault at $VAULT_PATH..."

DIRS=(
    "00-Inbox"
    "01-Work/Jira"
    "01-Work/1on1s"
    "01-Work/OKRs"
    "01-Work/Senior-Promotion"
    "02-Learning/AI-LLM"
    "03-Personal/Projects"
    "04-Routines"
    "standup"
    "Templates"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$VAULT_PATH/$dir"
done

# Copy template files (don't overwrite existing)
for f in "$REPO_DIR/vault-template/Templates/"*.md; do
    dest="$VAULT_PATH/Templates/$(basename "$f")"
    if [[ ! -f "$dest" ]]; then
        cp "$f" "$dest"
        info "  Created $dest"
    fi
done

# Create Dashboard.md if missing
DASHBOARD="$VAULT_PATH/Dashboard.md"
if [[ ! -f "$DASHBOARD" ]]; then
    sed "s/{{date}}/$(date +%Y-%m-%d)/g" \
        "$REPO_DIR/vault-template/Dashboard.md" > "$DASHBOARD"
    info "  Created Dashboard.md"
fi

# Create .gitignore
GITIGNORE="$VAULT_PATH/.gitignore"
if [[ ! -f "$GITIGNORE" ]]; then
    cat > "$GITIGNORE" << 'EOF'
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.trash/
.DS_Store
EOF
    info "  Created .gitignore"
fi

success "Vault scaffolded at $VAULT_PATH"

# ── 5. Write CLAUDE.md ──────────────────────────────────────────────────────

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
mkdir -p "$HOME/.claude"

if [[ -f "$CLAUDE_MD" ]]; then
    warn "~/.claude/CLAUDE.md already exists — skipping (not overwriting)."
    warn "Manually merge from: $REPO_DIR/claude/CLAUDE.md.template"
else
    sed \
        -e "s|{{YOUR_NAME}}|$YOUR_NAME|g" \
        -e "s|{{YOUR_VAULT_PATH}}|$VAULT_PATH|g" \
        -e "s|{{YOUR_JIRA_ORG}}|$JIRA_ORG|g" \
        -e "s|{{YOUR_JIRA_PROJECT}}|$JIRA_PROJECT|g" \
        -e "s|{{YOUR_GITHUB_USERNAME}}|$GITHUB_USER|g" \
        -e "s|{{TICKET-PREFIX}}|$JIRA_PROJECT|g" \
        "$REPO_DIR/claude/CLAUDE.md.template" > "$CLAUDE_MD"
    success "~/.claude/CLAUDE.md written"
fi

# ── 6. Install skills ───────────────────────────────────────────────────────

SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

for skill in "$REPO_DIR/claude/skills/"*.md; do
    dest="$SKILLS_DIR/$(basename "$skill")"
    if [[ -f "$dest" ]]; then
        warn "  Skill already exists: $(basename "$skill") — skipping"
    else
        # Replace vault path placeholder
        sed "s|{{YOUR_VAULT_PATH}}|$VAULT_PATH|g" "$skill" > "$dest"
        info "  Installed: $(basename "$skill")"
    fi
done

success "Skills installed to $SKILLS_DIR"

# ── 7. Git init vault ───────────────────────────────────────────────────────

if [[ ! -d "$VAULT_PATH/.git" ]]; then
    read -rp "Initialize git repo in vault? [y/N] " GIT_INIT
    if [[ "$GIT_INIT" =~ ^[Yy]$ ]]; then
        git -C "$VAULT_PATH" init
        git -C "$VAULT_PATH" add .
        git -C "$VAULT_PATH" commit -m "feat: initial vault scaffold"
        success "Git repo initialized"
    fi
fi

# ── 8. Print MCP config ─────────────────────────────────────────────────────

echo ""
echo "======================================"
echo "  MCP configuration"
echo "======================================"
echo ""
echo "Add this to ~/.claude/settings.json (or your LLM's MCP config):"
echo ""
cat << 'EOF'
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace-mcp",
      "args": []
    }
  }
}
EOF
echo ""

# ── Done ────────────────────────────────────────────────────────────────────

echo ""
echo "======================================"
echo "  Setup complete!"
echo "======================================"
echo ""
echo "  Vault:      $VAULT_PATH"
echo "  CLAUDE.md:  $CLAUDE_MD"
echo "  Skills:     $SKILLS_DIR"
echo "  MemPalace:  $PALACE_DIR"
echo ""
echo "Next steps:"
echo "  1. Add the MCP config above to ~/.claude/settings.json"
echo "  2. Open $VAULT_PATH in Obsidian"
echo "  3. cd $VAULT_PATH && claude"
echo "  4. Type: second-brain-sync"
echo ""
