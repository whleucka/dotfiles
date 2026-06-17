# ============================================================================
# ZSH Configuration
# ============================================================================

# Source environment variables first
[[ -f ~/.zshenv ]] && source ~/.zshenv

# Auto-start tmux and restore sessions after reboot
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
    if ! tmux has-session -t __server 2>/dev/null; then
        # Creates __server session which loads plugins, triggering continuum auto-restore
        tmux new-session -d -s __server
    fi
fi

# ----------------------------------------------------------------------------
# Powerlevel10k Instant Prompt (must be near top)
# ----------------------------------------------------------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------
export TMPDIR="/tmp"
export GPG_TTY=$(tty)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PKGEXT='.pkg.tar'

# Path
export PATH="$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin:$HOME/.bin/scripts:$HOME/.local/bin:/usr/local/go/bin:$HOME/bin/scripts:/usr/local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# Terminal
if [[ -n "$NVIM" ]]; then
    : # inside nvim's terminal — keep the TERM nvim gave us
elif [[ -n "$TMUX" ]]; then
    export TERM="tmux-256color"
elif [[ "$TERM" == "xterm-kitty" ]]; then
    export TERM="xterm-kitty"
else
    export TERM="xterm-256color"
fi

# Editor (prefer nvim > vim > vi > nano)
if command -v nvim &>/dev/null; then
    export VISUAL="nvim"
elif command -v vim &>/dev/null; then
    export VISUAL="vim"
else
    export VISUAL="${commands[vi]:-nano}"
fi
export EDITOR="$VISUAL"

# ----------------------------------------------------------------------------
# FZF Configuration
# ----------------------------------------------------------------------------
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%,40%"

# File search with ripgrep
if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,vendor,node_modules}/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# File preview with bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"

# Directory preview with eza (or ls fallback)
if command -v eza &>/dev/null; then
    export FZF_ALT_C_OPTS="--preview 'eza -1 --color=always --icons {}'"
else
    export FZF_ALT_C_OPTS="--preview 'ls -1 --color=always {}'"
fi

# ----------------------------------------------------------------------------
# Oh My Zsh
# ----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Options
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
UPDATE_ZSH_DAYS=7
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
    git
    sudo
    rsync
    zsh-256color
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ----------------------------------------------------------------------------
# Zoxide (modern autojump replacement)
# ----------------------------------------------------------------------------
eval "$(zoxide init zsh)"

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
# History search with up/down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# Tab completion navigation
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete

# Kitty keyboard protocol sends ctrl+e as CSI 1;9u — bind it to end-of-line
bindkey '\e[1;9u' end-of-line

# ----------------------------------------------------------------------------
# Kitty/Ghostty Integration (after oh-my-zsh so autosuggestions widget is intact)
# ----------------------------------------------------------------------------
if [[ -f /usr/lib/kitty/shell-integration/zsh/kitty.zsh ]]; then
    source /usr/lib/kitty/shell-integration/zsh/kitty.zsh
fi

# ----------------------------------------------------------------------------
# FZF (load after oh-my-zsh)
# ----------------------------------------------------------------------------
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi

# ----------------------------------------------------------------------------
# Local Configuration
# ----------------------------------------------------------------------------
[[ -f ~/.aliasrc ]] && source ~/.aliasrc
[[ -f ~/.functions ]] && source ~/.functions
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ----------------------------------------------------------------------------
# Bat Integration (must be after sourcing functions to avoid alias conflicts)
# ----------------------------------------------------------------------------
if command -v bat &>/dev/null; then
    export MANROFFOPT="-c"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
    alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
