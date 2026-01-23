export TMPDIR="/tmp"

# mantis.nvim config
export MANTIS_WH=t9AN4GevwixYFrc9OUZC8H21vgCwIZB2

export POWERLEVEL9K_INSTANT_PROMPT=quiet

# SSH gpg key
export GPG_TTY=$(tty)

# if command -v fastfetch >/dev/null; then
#     sh -c $(which fastfetch)
# fi

if type kitty &> /dev/null; then
    export TERM="xterm-kitty"
else
    export TERM="xterm-256color"
fi

# global defaults
export FZF_DEFAULT_OPTS="-m --color=dark --bind=alt-k:up,alt-j:down --height=30% --layout=reverse --border"

# only for Ctrl-T (file picker)
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# define the file command
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow -g "!{.git,vendor,node_modules}/*"'
fi

FZF_ALT_C_OPTS="--preview 'exa -1 --color=always {}'"
#FZF_CTRL_R_OPTS="--preview 'echo {}'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_TMUX=1  # optional

# Caps lock is not needed..
# xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.cargo/bin:$HOME/.config/composer/vendor/bin:$HOME/.bin/scripts:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/bin/scripts:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    zsh-256color
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    autojump
    rsync
    sudo
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Better search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
bindkey '^[OB'  down-line-or-beginning-search

# Preferred editor for local and remote sessions
if command -v nvim >/dev/null; then
    export VISUAL="nvim"
elif command -v vim >/dev/null; then
    export VISUAL="vim"
elif command -v vi >/dev/null; then
    export VISUAL="vi"
else
    export VISUAL="nano"
fi
export EDITOR="$VISUAL"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
[[ ! -f $HOME/.aliasrc ]] || source $HOME/.aliasrc
[[ ! -f $HOME/.functions ]] || source $HOME/.functions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ctrl+n ctrl+p move through list
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete
# Press ctrl+e to complete autosuggest
# Disable arrow completion
#ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
#bindkey '^I'      autosuggest-accept
#ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
#ZSH_AUTOSUGGEST_STRATEGY=(history completion)
#ZSH_AUTOSUGGEST_USE_ASYNC=true
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#export PAGER="nvim -u NONE"

if command -v bat > /dev/null ; then
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
    alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
    alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi

# Faster compression
export PKGEXT='.pkg.tar'

# pnpm
export PNPM_HOME="/home/whleucka/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/p10k/.p10k.zsh.
[[ ! -f ~/.dotfiles/p10k/.p10k.zsh ]] || source ~/.dotfiles/p10k/.p10k.zsh

# Kitty shell integration
if [[ -f /usr/lib/kitty/shell-integration/zsh/kitty.zsh ]]; then
    source /usr/lib/kitty/shell-integration/zsh/kitty.zsh;
fi
