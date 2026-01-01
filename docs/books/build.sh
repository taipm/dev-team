#!/bin/bash

# Build script for @microai.club/dev-team documentation books
# Usage: ./build.sh [book] [lang]
#   ./build.sh              # Build all books
#   ./build.sh user-guide   # Build user-guide (both languages)
#   ./build.sh user-guide vi # Build user-guide Vietnamese only

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Books and languages
BOOKS=("user-guide" "developer-guide" "reference")
LANGS=("vi" "en")

# Helper functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if mdbook is installed
check_mdbook() {
  if ! command -v mdbook &> /dev/null; then
    log_error "mdbook is not installed!"
    echo ""
    echo "Install mdbook using one of these methods:"
    echo "  - macOS (Homebrew): brew install mdbook"
    echo "  - Cargo (Rust): cargo install mdbook"
    echo "  - Download: https://github.com/rust-lang/mdBook/releases"
    exit 1
  fi
  log_info "mdbook version: $(mdbook --version)"
}

# Build a single book
build_book() {
  local book=$1
  local lang=$2

  local book_dir="$SCRIPT_DIR/$book/$lang"

  if [ ! -d "$book_dir" ]; then
    log_warning "Directory not found: $book_dir"
    return 1
  fi

  if [ ! -f "$book_dir/book.toml" ]; then
    log_warning "book.toml not found in: $book_dir"
    return 1
  fi

  log_info "Building $book ($lang)..."

  cd "$book_dir"

  if mdbook build; then
    log_success "Built $book ($lang)"
  else
    log_error "Failed to build $book ($lang)"
    return 1
  fi

  cd "$SCRIPT_DIR"
}

# Build all books
build_all() {
  log_info "Building all books..."
  echo ""

  local total=0
  local success=0
  local failed=0

  for book in "${BOOKS[@]}"; do
    for lang in "${LANGS[@]}"; do
      ((total++))
      if build_book "$book" "$lang"; then
        ((success++))
      else
        ((failed++))
      fi
    done
  done

  echo ""
  log_info "Build complete: $success/$total successful"

  if [ $failed -gt 0 ]; then
    log_warning "$failed builds failed"
    exit 1
  fi
}

# Serve a book for development
serve_book() {
  local book=$1
  local lang=$2

  local book_dir="$SCRIPT_DIR/$book/$lang"

  if [ ! -d "$book_dir" ]; then
    log_error "Directory not found: $book_dir"
    exit 1
  fi

  log_info "Serving $book ($lang) at http://localhost:3000"
  cd "$book_dir"
  mdbook serve --open
}

# Clean build directory
clean() {
  log_info "Cleaning build directory..."
  rm -rf "$SCRIPT_DIR/build"
  log_success "Build directory cleaned"
}

# Show help
show_help() {
  echo "Dev-Team Documentation Builder"
  echo ""
  echo "Usage: ./build.sh [command] [book] [lang]"
  echo ""
  echo "Commands:"
  echo "  build [book] [lang]  Build books (default: all)"
  echo "  serve <book> <lang>  Serve a book for development"
  echo "  clean                Clean build directory"
  echo "  help                 Show this help"
  echo ""
  echo "Books: user-guide, developer-guide, reference"
  echo "Languages: vi, en"
  echo ""
  echo "Examples:"
  echo "  ./build.sh                          # Build all books"
  echo "  ./build.sh build user-guide         # Build user-guide (both langs)"
  echo "  ./build.sh build user-guide vi      # Build user-guide Vietnamese"
  echo "  ./build.sh serve user-guide vi      # Serve user-guide Vietnamese"
  echo "  ./build.sh clean                    # Clean build directory"
}

# Main
main() {
  check_mdbook

  local command=${1:-build}
  local book=$2
  local lang=$3

  case $command in
    build)
      if [ -n "$book" ] && [ -n "$lang" ]; then
        build_book "$book" "$lang"
      elif [ -n "$book" ]; then
        for l in "${LANGS[@]}"; do
          build_book "$book" "$l"
        done
      else
        build_all
      fi
      ;;
    serve)
      if [ -z "$book" ] || [ -z "$lang" ]; then
        log_error "Usage: ./build.sh serve <book> <lang>"
        exit 1
      fi
      serve_book "$book" "$lang"
      ;;
    clean)
      clean
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      log_error "Unknown command: $command"
      show_help
      exit 1
      ;;
  esac
}

main "$@"
