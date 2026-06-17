# ~/.bashrc — executed for interactive non-login shells
# For login shells, source this from ~/.bash_profile:
#   [[ -f ~/.bashrc ]] && . ~/.bashrc

# ── Early exit for non-interactive shells ────────────────────────────────────
[[ $- != *i* ]] && return

# ── TERM ─────────────────────────────────────────────────────────────────────
# Do NOT override TERM if it was set by the parent (SSH, tmux, kitty, nvim).
# Only set a sane default if nothing arrived.
if [[ -z "$TERM" ]]; then
    export TERM="xterm-256color"
fi

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth        # ignore duplicates and lines starting with space
HISTTIMEFORMAT="%F %T  "
shopt -s histappend           # append rather than overwrite on exit
shopt -s cmdhist              # save multi-line commands as one entry

# ── Shell options ─────────────────────────────────────────────────────────────
shopt -s checkwinsize         # update LINES/COLUMNS after each command
shopt -s globstar             # ** recursive glob
shopt -s autocd               # type a dir name to cd into it
shopt -s cdspell              # minor typo correction for cd

# ── Aliases ───────────────────────────────────────────────────────────────────
[[ -f ~/.aliasrc ]] && . ~/.aliasrc

# ── Prompt ────────────────────────────────────────────────────────────────────
# Colors only when the terminal supports them
if tput setaf 1 &>/dev/null; then
    # For use directly in PS1: \[ \] mark non-printing regions.
    _RESET='\[\e[0m\]'
    _BOLD='\[\e[1m\]'
    _RED='\[\e[31m\]'
    _GREEN='\[\e[32m\]'
    _YELLOW='\[\e[33m\]'
    _BLUE='\[\e[34m\]'
    _CYAN='\[\e[36m\]'
    # Raw-byte forms for use INSIDE $(...) prompt functions. Bash decodes
    # \[ \e \] only once, before command substitution runs, so substituted
    # output must carry real ESC (\033) and \001/\002 (the raw \[ \]) itself.
    _r_reset=$'\001\033[0m\002'
    _r_red=$'\001\033[31m\002'
    _r_yellow=$'\001\033[33m\002'
else
    _RESET='' _BOLD='' _RED='' _GREEN='' _YELLOW='' _BLUE='' _CYAN=''
    _r_reset='' _r_red='' _r_yellow=''
fi

# Capture the real exit status FIRST, before any prompt function runs and
# clobbers $? (e.g. _prompt_git's failing git call in a non-repo dir).
_save_status() { _LAST_STATUS=$?; }
PROMPT_COMMAND="_save_status${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Show exit code of last command if non-zero
_prompt_status() {
    [[ ${_LAST_STATUS:-0} -ne 0 ]] && printf ' %s✗%s%s' "$_r_red" "$_LAST_STATUS" "$_r_reset"
}

# Git branch in prompt
_prompt_git() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
    local dirty=""
    git diff --quiet 2>/dev/null || dirty="*"
    printf ' %s(%s%s)%s' "$_r_yellow" "$branch" "$dirty" "$_r_reset"
}

PS1="${_BOLD}${_GREEN}\u@\h${_RESET}:${_BOLD}${_BLUE}\w${_RESET}\$(_prompt_git)\$(_prompt_status)\n\$ "

# Simpler prompt inside nvim terminal (no git, no status noise)
[[ -n "$NVIM" ]] && PS1="${_CYAN}nvim${_RESET}:${_BOLD}${_BLUE}\w${_RESET}\n\$ "

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-RFX"            # -R colors, -F quit if one screen, -X no clear

# XDG base dirs (many tools respect these)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Local binaries
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]]        && export PATH="$HOME/bin:$PATH"

# ── Completions ───────────────────────────────────────────────────────────────
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

# ── Local overrides ───────────────────────────────────────────────────────────
# Machine-specific config that shouldn't be in version control
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

# Ensure .bashrc exits cleanly so the first prompt doesn't inherit a non-zero
# $? from a failed test above (e.g. the missing ~/.bashrc.local check).
true
