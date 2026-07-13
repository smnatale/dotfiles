#!/bin/bash

# Script to symlink opencode skills to claude skills
# This ensures all opencode skills are available in claude

# Define directories
OPENCODE_SKILLS_DIR="/Users/samnatale/dotfiles/opencode/.config/opencode/skills"
CLAUDE_SKILLS_DIR="/Users/samnatale/dotfiles/claude/.claude/skills"

# Create claude skills directory if it doesn't exist
echo "Creating claude skills directory if it doesn't exist..."
mkdir -p "$CLAUDE_SKILLS_DIR"

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
        ln -s "$skill_dir" "$symlink_path"
        
        echo "Symlinked: $skill_name"
    fi
done

echo "Done! Symlinked all opencode skills to claude skills."
echo ""
echo "Claude skills directory: $CLAUDE_SKILLS_DIR"
echo "Opencode skills directory: $OPENCODE_SKILLS_DIR"