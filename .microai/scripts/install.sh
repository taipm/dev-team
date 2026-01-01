#!/bin/bash
# install.sh - Install MicroAI agents and commands
# Usage: ./.microai/scripts/install.sh [--all|--commands|--help]
#
# This script copies commands from .microai/commands/ (library)
# to .claude/commands/microai/ (runtime) to activate slash commands

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Paths
MICROAI_COMMANDS=".microai/commands"
CLAUDE_COMMANDS=".claude/commands/microai"

print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              MICROAI INSTALLER v1.0                           ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${CYAN}○${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

show_help() {
    echo "Usage: ./.microai/scripts/install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all        Install all commands (default)"
    echo "  --commands   Install commands only"
    echo "  --list       List available commands"
    echo "  --uninstall  Remove installed commands"
    echo "  --help       Show this help"
    echo ""
    echo "Examples:"
    echo "  ./.microai/scripts/install.sh              # Install all"
    echo "  ./.microai/scripts/install.sh --list       # List commands"
    echo "  ./.microai/scripts/install.sh --uninstall  # Uninstall"
    echo ""
}

list_commands() {
    echo -e "${BLUE}=== Available Commands in Library ===${NC}"
    echo ""

    if [ ! -d "$MICROAI_COMMANDS" ]; then
        print_error "Library not found: $MICROAI_COMMANDS"
        exit 1
    fi

    # Count files
    local count=0

    # List .md files
    for cmd in "$MICROAI_COMMANDS"/*.md; do
        if [ -f "$cmd" ]; then
            local name=$(basename "$cmd" .md)
            local installed=""

            # Check if installed
            if [ -f "$CLAUDE_COMMANDS/$name.md" ]; then
                installed="${GREEN}[installed]${NC}"
            else
                installed="${YELLOW}[not installed]${NC}"
            fi

            echo -e "  /microai:$name $installed"
            count=$((count + 1))
        fi
    done

    # List directories with .md files
    for dir in "$MICROAI_COMMANDS"/*/; do
        if [ -d "$dir" ]; then
            local dirname=$(basename "$dir")
            for cmd in "$dir"*.md; do
                if [ -f "$cmd" ]; then
                    local name=$(basename "$cmd" .md)
                    local installed=""

                    if [ -f "$CLAUDE_COMMANDS/$dirname/$name.md" ]; then
                        installed="${GREEN}[installed]${NC}"
                    else
                        installed="${YELLOW}[not installed]${NC}"
                    fi

                    echo -e "  /microai:$dirname:$name $installed"
                    count=$((count + 1))
                fi
            done
        fi
    done

    echo ""
    echo "Total: $count commands"
}

install_commands() {
    echo -e "${BLUE}=== Installing Commands ===${NC}"
    echo ""

    # Create target directory if not exists
    if [ ! -d "$CLAUDE_COMMANDS" ]; then
        mkdir -p "$CLAUDE_COMMANDS"
        print_success "Created $CLAUDE_COMMANDS"
    fi

    local installed=0
    local skipped=0
    local updated=0

    # Copy .md files
    for cmd in "$MICROAI_COMMANDS"/*.md; do
        if [ -f "$cmd" ]; then
            local name=$(basename "$cmd")
            local target="$CLAUDE_COMMANDS/$name"

            if [ -f "$target" ]; then
                # Check if different
                if ! cmp -s "$cmd" "$target"; then
                    cp "$cmd" "$target"
                    print_success "Updated: $name"
                    updated=$((updated + 1))
                else
                    print_info "Skipped (same): $name"
                    skipped=$((skipped + 1))
                fi
            else
                cp "$cmd" "$target"
                print_success "Installed: $name"
                installed=$((installed + 1))
            fi
        fi
    done

    # Copy directories
    for dir in "$MICROAI_COMMANDS"/*/; do
        if [ -d "$dir" ]; then
            local dirname=$(basename "$dir")
            local target_dir="$CLAUDE_COMMANDS/$dirname"

            # Create subdirectory
            if [ ! -d "$target_dir" ]; then
                mkdir -p "$target_dir"
            fi

            # Copy files in directory
            for cmd in "$dir"*.md; do
                if [ -f "$cmd" ]; then
                    local name=$(basename "$cmd")
                    local target="$target_dir/$name"

                    if [ -f "$target" ]; then
                        if ! cmp -s "$cmd" "$target"; then
                            cp "$cmd" "$target"
                            print_success "Updated: $dirname/$name"
                            updated=$((updated + 1))
                        else
                            print_info "Skipped (same): $dirname/$name"
                            skipped=$((skipped + 1))
                        fi
                    else
                        cp "$cmd" "$target"
                        print_success "Installed: $dirname/$name"
                        installed=$((installed + 1))
                    fi
                fi
            done
        fi
    done

    echo ""
    echo -e "${BLUE}=== Summary ===${NC}"
    echo "  Installed: $installed"
    echo "  Updated:   $updated"
    echo "  Skipped:   $skipped"
}

uninstall_commands() {
    echo -e "${BLUE}=== Uninstalling Commands ===${NC}"
    echo ""

    if [ ! -d "$CLAUDE_COMMANDS" ]; then
        print_warn "Nothing to uninstall: $CLAUDE_COMMANDS not found"
        return
    fi

    local removed=0

    # Remove files that exist in library
    for cmd in "$MICROAI_COMMANDS"/*.md; do
        if [ -f "$cmd" ]; then
            local name=$(basename "$cmd")
            local target="$CLAUDE_COMMANDS/$name"

            if [ -f "$target" ]; then
                rm "$target"
                print_success "Removed: $name"
                removed=$((removed + 1))
            fi
        fi
    done

    # Remove directories
    for dir in "$MICROAI_COMMANDS"/*/; do
        if [ -d "$dir" ]; then
            local dirname=$(basename "$dir")
            local target_dir="$CLAUDE_COMMANDS/$dirname"

            if [ -d "$target_dir" ]; then
                rm -rf "$target_dir"
                print_success "Removed directory: $dirname/"
                removed=$((removed + 1))
            fi
        fi
    done

    echo ""
    echo "Removed: $removed items"
}

# Main
print_header

# Check we're in project root
if [ ! -d ".microai" ]; then
    print_error "Must run from project root (where .microai/ exists)"
    exit 1
fi

# Parse arguments
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --list|-l)
        list_commands
        ;;
    --uninstall|-u)
        uninstall_commands
        ;;
    --commands|-c|--all|"")
        install_commands
        echo ""
        print_success "Installation complete!"
        echo ""
        echo "Commands are now available as /microai:{name}"
        echo "Example: /microai:root-cause"
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
