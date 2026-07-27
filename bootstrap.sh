#!/bin/bash
# First contact: bare machine + curl -> dotfiles checked out in $HOME.
#
#   curl -fL https://raw.githubusercontent.com/gavento/dotfiles/main/bootstrap.sh | bash
#   curl -fL .../bootstrap.sh | bash -s -- --system --class rich
#
# Deliberately standalone: it runs before the repo exists, so it cannot rely on
# anything inside it. Everything afterwards is `dotfiles`.
#
# Flow: clone the repo, extract just this repo's machinery (yadm, dotfiles,
# tools.tsv), install the pinned tools, then check out the rest. That last
# checkout NEVER overwrites a pre-existing file -- git refuses and names every
# conflicting path, you move those aside, and `dotfiles checkout` finishes the
# job. A bootstrap that silently ate an existing ~/.zshrc or ~/.ssh/config
# would be a far worse failure than an interrupted one.
#
# yadm is NOT downloaded here. It is vendored in the repo at .local/bin/yadm,
# and a yadm repo is just a bare git repo with three config settings -- so
# plain git can lay it down, and the checkout materialises yadm itself.
# Requirement on a bare box is therefore: git, and zsh if you want the shell.
#
# Everything below is defined as functions and only run from main() at the very
# bottom, so a truncated download (`curl | bash` over a dropped connection)
# cannot execute half a script.

set -e -u -o pipefail

REPO_URL="${DOTFILES_URL:-https://github.com/gavento/dotfiles}"
REPO_DIR="$HOME/.local/share/yadm/repo.git"
CLASS=""
DO_SYSTEM=0
DO_TOOLS=1

# This repo's own machinery, as opposed to user data: needed before the real
# checkout, and safe to overwrite because it is ours.
TOOLING=(.local/bin/yadm .local/bin/dotfiles .local/share/dotfiles/tools.tsv)

usage() {
    cat <<'EOF'
Usage: bootstrap.sh [options]

  --system          Install base packages first (needs root or sudo)
  --class <name>    Set the machine class: base (default) or rich
  --no-tools        Skip pinned tool installation (fzf, uv, gitleaks)
  --url <git-url>   Override the dotfiles repository URL
  -h, --help
EOF
}

# Every call into the repo goes through this. The -C matters: later calls use
# pathspecs, which git resolves relative to the current directory, not to the
# work tree.
g() { git -C "$HOME" --git-dir="$REPO_DIR" --work-tree="$HOME" "$@"; }

# --------------------------------------------------------------------------
# Tooling extraction
# --------------------------------------------------------------------------
#
# Two git subtleties make this less obvious than `git checkout HEAD -- <paths>`.
#
# `git checkout` fills a work tree only from an EMPTY index. Give it entries
# and every path missing from it reads as a local deletion to preserve, so the
# checkout below turns into a silent no-op -- and so would the `dotfiles
# checkout` we tell the user to finish with. Hence the throwaway index: the
# real one stays untouched and the classic bare-repo checkout still works.
#
# git's untracked-file guard is content-blind: a file it is about to write
# blocks the checkout even when byte-identical, so the extracted files would
# make the checkout refuse on this repo's own machinery. Listing them in the
# repo's private exclude file exempts them (checkout silently overwrites
# IGNORED files), and the entries are taken out again the moment the real
# checkout succeeds. A refused run keeps them, because the user's later
# `dotfiles checkout` needs the same exemption; they go inert anyway once the
# paths are tracked.

extract_tooling() {
    local excl="$REPO_DIR/info/exclude" idx="$REPO_DIR/bootstrap.index" p
    mkdir -p "$REPO_DIR/info"
    touch "$excl"
    for p in "${TOOLING[@]}"; do
        grep -qxF "/$p" "$excl" || printf '/%s\n' "$p" >> "$excl"
    done

    rm -f "$idx"
    ( export GIT_INDEX_FILE="$idx"; g checkout HEAD -- "${TOOLING[@]}" )
    rm -f "$idx"

    chmod +x "$HOME/.local/bin/yadm" "$HOME/.local/bin/dotfiles"
}

unexclude_tooling() {
    local excl="$REPO_DIR/info/exclude" p
    [[ -f "$excl" ]] || return 0
    for p in "${TOOLING[@]}"; do
        grep -vxF "/$p" "$excl" > "$excl.tmp" || true
        mv "$excl.tmp" "$excl"
    done
}

# --------------------------------------------------------------------------
# Optional: system packages
# --------------------------------------------------------------------------

install_system_packages() {
    local packages="zsh git curl tmux nano vim mc"
    local missing="" p
    for p in $packages; do
        command -v "$p" >/dev/null 2>&1 || missing="$missing $p"
    done
    [[ -n "$missing" ]] || { echo "System packages already present."; return 0; }

    local SUDO=""
    if [[ "$(id -u)" -ne 0 ]]; then
        command -v sudo >/dev/null 2>&1 || { echo "bootstrap: need root or sudo for --system" >&2; exit 1; }
        SUDO=sudo
    fi

    echo "Installing:$missing"
    if   command -v apt-get >/dev/null 2>&1; then $SUDO apt-get update && $SUDO apt-get install -y $missing
    elif command -v dnf     >/dev/null 2>&1; then $SUDO dnf install -y $missing
    elif command -v pacman  >/dev/null 2>&1; then $SUDO pacman -Sy --noconfirm $missing
    elif command -v zypper  >/dev/null 2>&1; then $SUDO zypper install -y $missing
    elif command -v apk     >/dev/null 2>&1; then $SUDO apk add $missing
    else
        echo "bootstrap: no supported package manager (apt/dnf/pacman/zypper/apk)" >&2
        exit 1
    fi
}

# --------------------------------------------------------------------------

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --system)   DO_SYSTEM=1; shift ;;
            --class)    CLASS="${2:?--class needs a value}"; shift 2 ;;
            --no-tools) DO_TOOLS=0; shift ;;
            --url)      REPO_URL="${2:?--url needs a value}"; shift 2 ;;
            -h|--help)  usage; exit 0 ;;
            *) echo "bootstrap: unknown option $1" >&2; usage >&2; exit 1 ;;
        esac
    done

    (( DO_SYSTEM )) && install_system_packages

    command -v git >/dev/null 2>&1 || { echo "bootstrap: git is required" >&2; exit 1; }

    # ----------------------------------------------------------------------
    # Lay down the repo
    # ----------------------------------------------------------------------

    if [[ -d "$REPO_DIR" ]]; then
        echo "Repo already present at $REPO_DIR -- use 'dotfiles update' instead."
    else
        echo "Cloning $REPO_URL ..."
        git clone --bare "$REPO_URL" "$REPO_DIR"

        g config core.bare false
        g config core.worktree "$HOME"
        g config status.showUntrackedFiles normal

        # `git clone --bare` leaves a mirror refspec (+refs/heads/*:refs/heads/*),
        # so there are no remote-tracking refs and @{upstream} never resolves --
        # which would make `dotfiles update` report "already up to date" forever
        # while commits pile up upstream. Give it a normal fetch layout instead.
        g config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
        g fetch --quiet origin

        local branch
        branch=$(g symbolic-ref --short HEAD 2>/dev/null || echo main)
        g branch --set-upstream-to="origin/$branch" "$branch" >/dev/null 2>&1 || true
    fi

    # ----------------------------------------------------------------------
    # Tooling first, then the rest of $HOME
    # ----------------------------------------------------------------------

    extract_tooling

    [[ -n "$CLASS" ]] && "$HOME/.local/bin/dotfiles" class "$CLASS"

    # No -f: git refuses the checkout if it would clobber an untracked file,
    # and prints the full list of them. Nothing is lost and nothing is half
    # applied -- the user moves those files aside and finishes the checkout.
    local refused=0
    echo "Checking out into \$HOME ..."
    if g checkout; then
        unexclude_tooling
        echo "Checked out into $HOME."
    else
        refused=1
        echo
        echo "bootstrap: checkout refused -- the files git listed above already" >&2
        echo "           exist in \$HOME. Nothing was overwritten." >&2
        echo "           Move each one aside, e.g." >&2
        echo "               mv ~/.zshrc ~/.zshrc.pre-dotfiles" >&2
        echo "           then finish with:" >&2
        echo "               dotfiles checkout" >&2
        echo "           ('dotfiles' passes unknown subcommands through to yadm/git.)" >&2
    fi

    # ----------------------------------------------------------------------
    # Tools and shell
    # ----------------------------------------------------------------------

    # Independent of the checkout above: dotfiles and tools.tsv are already in
    # place, and tools install into ~/.local/bin, which holds no user data.
    if (( DO_TOOLS )); then
        "$HOME/.local/bin/dotfiles" tools install || echo "bootstrap: tool install had problems (continuing)" >&2
    fi

    if [[ "${SHELL:-}" != *zsh ]] && command -v zsh >/dev/null 2>&1; then
        echo
        echo "zsh is installed but not your login shell. To switch:"
        echo "    chsh -s \"$(command -v zsh)\""
    fi

    echo
    if (( refused )); then
        echo "Move the files git listed aside, then 'dotfiles checkout' to finish."
    else
        echo "Done. 'dotfiles status' to see the state of \$HOME."
    fi
}

main "$@"
