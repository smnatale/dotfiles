#!/bin/bash
set -e

# Script to symlink opencode skills to claude and codex skills
# This ensures all opencode skills are available in claude and codex

# Derive paths from script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_SKILLS_DIR="$SCRIPT_DIR/opencode/.config/opencode/skills"
CLAUDE_SKILLS_DIR="$SCRIPT_DIR/claude/.claude/skills"
CODEX_SKILLS_DIR="$SCRIPT_DIR/codex/.codex/skills"

# Create skills directories if they don't exist
echo "Creating skills directories if they don't exist..."
mkdir -p "$CLAUDE_SKILLS_DIR"
mkdir -p "$CODEX_SKILLS_DIR"

# Check if opencode skills directory exists
if [ ! -d "$OPENCODE_SKILLS_DIR" ]; then
    echo "Error: Opencode skills directory not found at $OPENCODE_SKILLS_DIR"
    exit 1
fi

# Loop through each skill in opencode skills directory
echo "Symlinking opencode skills to claude skills..."
for skill_dir in "$OPENCODE_SKILLS_DIR"/*/; do
    # Check if SKILL.md exists in the skill directory
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        symlink_path="$CLAUDE_SKILLS_DIR/$skill_name"

        # Remove existing symlink or directory if it exists
        if [ -L "$symlink_path" ] || [ -d "$symlink_path" ]; then
            rm -rf "$symlink_path"
        fi

        # Create symlink to the opencode skill directory
        ln -s "${skill_dir%/}" "$symlink_path"

        echo "Symlinked: $skill_name"
    fi
done

# Loop through each skill in opencode skills directory for codex
echo "Symlinking opencode skills to codex skills..."
for skill_dir in "$OPENCODE_SKILLS_DIR"/*/; do
    # Check if SKILL.md exists in the skill directory
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        symlink_path="$CODEX_SKILLS_DIR/$skill_name"

        # Remove existing symlink or directory if it exists
        if [ -L "$symlink_path" ] || [ -d "$symlink_path" ]; then
            rm -rf "$symlink_path"
        fi

        # Create symlink to the opencode skill directory
        ln -s "${skill_dir%/}" "$symlink_path"

        echo "Symlinked: $skill_name"
    fi
done

echo "Done! Symlinked all opencode skills to claude and codex skills."
echo ""
echo "Claude skills directory: $CLAUDE_SKILLS_DIR"
echo "Codex skills directory: $CODEX_SKILLS_DIR"
echo "Opencode skills directory: $OPENCODE_SKILLS_DIR"
