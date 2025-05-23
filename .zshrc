# vim:ft=zsh:foldmethod=marker:foldlevel=0:
umask 022

typeset -U fpath
fpath=(
	~/.local/share/zsh/site-functions(N-/)
	/opt/homebrew/share/zsh/site-functions(N-/)
	/usr/local/share/zsh/site-functions(N-/)
	/usr/share/zsh/site-functions(N-/)
	$fpath
)

autoload -Uz compinit

# ENV {{{
export EDITOR='nvim'
export PAGER='less'

# CD
cdpath=(~ ~/.local/src/github.com/glyzinie)

# Less
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSHISTFILE=-

# LS (GNU)
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ---

# bun
export BUN_INSTALL="$HOME/.bun"
path=($BUN_INSTALL/bin(N-/) $path)

# Go
export GOPATH="$XDG_DATA_HOME/go"
path=($GOPATH/bin(N-/) $path)

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
path=($CARGO_HOME/bin(N-/) $path)

# Py
path=(~/Library/Python/3.9/bin(N-/) $path)

# ---

# bat
if (( $+commands[bat] )); then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# GHQ
export GHQ_ROOT="$HOME/.local/src"

# Mocword
if [[ -f "$XDG_DATA_HOME/mocword/mocword.sqlite" ]]; then
	export MOCWORD_DATA="$XDG_DATA_HOME/mocword/mocword.sqlite"
fi

# fzf
# TODO: 調整
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ---

path=(~/.local/bin(N-/) $path ~/.local/share/nvim/mason/bin(N-/))
# }}}
# Alias {{{
# LS
if (( $+commands[eza] )); then
	alias ls="eza --group-directories-first --icons"
	alias la="eza -a --group-directories-first --icons"
	alias ll="eza -l --group-directories-first --icons --git --time-style=relative"
	alias lla="eza -la --group-directories-first --icons --git --time-style=relative"
else
	if (( $+commands[sw_vers] )); then
		alias ls='ls -F -G'
	else
		alias ls='ls -F --color=auto'
	fi
	alias la="ls -A"
	alias ll="ls -l"
	alias lla="ls -lA"
fi

# 高機能 mv
autoload -Uz zmv
alias rename='noglob zmv -W'

# Suffix Alias
if (( $+commands[open] ));then
	alias -s html='open'
fi
if (( $+commands[unar] )); then
	alias -s {gz,zip,7z}='unar'
fi

# Tailscale (macOS)
if [[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
	alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
fi
# }}}
# Comp {{{
# 単語の区切りを調整
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# キャッシュを使う
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zcompdumps"

# compctl を使用しない
zstyle ':completion:*' use-compctl false

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# 補完候補をカーソルで選ぶ
zstyle ':completion:*:default' menu select=2

# sudo でも補完する
zstyle ':completion::complete:*' gain-privileges 1

# remove trailing spaces after completion if needed
# 自動補完される余分なカンマなどを適宜削除してスムーズに入力できるようにする
# https://qiita.com/t_uda/items/eb2e6bd25d99f64d78df
setopt auto_param_keys

# ディレクトリ名補完とき / 付与
setopt auto_param_slash

# 補完のときプロンプトの位置を変えない
setopt always_last_prompt

# 語の途中でもカーソル位置で補完
setopt complete_in_word

# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# 補完メッセージを読みやすくする
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'

# 補完候補を一覧で表示する
setopt auto_list

# 補完候補一覧でファイルの種別を識別マーク表示 (ls -F の記号)
setopt list_types

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# 補完キー連打で順に補完候補を自動で補完
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# Deploy {a-c} -> a b c
setopt brace_ccl

# Expand '=command' as path of command.
# e.g.) '=ls' -> '/bin/ls's
setopt equals

# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots

# ignore
## rm を除く設定
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o|*?.d|*?.aux|*?~|*\#'

## cd
zstyle ':completion:*:cd:*' ignored-patterns '*CVS|*.git|*lost+found'

## ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# color
## 候補のfileに色付け
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## kill 候補を色付け
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# スペルミス修正
setopt correct
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'
# }}}
# Func {{{
showopt() {
	set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}

# Fuzzy
# TODO: 最適化
local FUZZY="fzy"

## Editor
e() {
	local file=$(git ls-tree -r --name-only HEAD || fd --type f --hidden --follow --exclude .git)
	local selected=$(echo $file | $FUZZY)
	[[ -f "$selected" ]] && nvim $selected
}

## GHQ
g() {
	local repo=$(ghq list --unique "$1" | $FUZZY)
	local path=$(ghq list --full-path --exact "$repo")
	[[ -d "$path" ]] && cd "$path"
}
# }}}
# Hist {{{
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=1000000000
if [ $UID = 0 ]; then
	unset HISTFILE
	SAVEHIST=0
fi

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# }}}
# Keybind {{{
bindkey -v

# <C-x>e: edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^xe' edit-command-line
bindkey -M vicmd '^xe' edit-command-line

# <C-]>: 一つ前のコマンドの最後の単語を挿入
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word

# <Up>/<Down>: 履歴検索
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# }}}
# Abbrev {{{
typeset -g -A _abbreviations=(
	"e" "$EDITOR"
	"q" "exit"
	"sk" "ssh-keygen -t ed25519 -C \$(git config --get user.email)"
	# git: get branch name
	"B" "\$(git symbolic-ref --short HEAD)"
	# PIPE
	"C" "| wc -l"
	"P" "| $PAGER"
)

## Copy to clipboard
if (( $+commands[wl-copy] )); then
	_abbreviations[CP]="| wl-copy"
elif (( $+commands[pbcopy] )); then
	_abbreviations[CP]="| pbcopy"
elif (( $+commands[xclip] )); then
	_abbreviations[CP]="| xclip -in -selection clipboard"
elif (( $+commands[xsel] )); then
	_abbreviations[CP]="| xsel --input --clipboard"
fi

# bottom
if (( $+commands[btm] )); then
	_abbreviations[top]="btm"
fi

# dig
if (( $+commands[dig] - 1 )) && (( $+commands[drill] )); then
	_abbreviations[dig]="drill"
fi

# Git {{{
if (( $+commands[git] )); then
_abbreviations+=(
	"ga"  "git add"
	"gb" "git branch"
	"gap" "git add -p"
	"gcm" "git commit"
	"gco" "git checkout"
	"gcob" "git checkout -b"
	"gcobp" "git checkout -b patch"
	"gd" "git diff"
	"gf" "git fetch"
	"gfu" "git fetch upstream"
	"gp" "git push"
	"gpd" "git push dev"
	"gpo" "git push origin"
	"gr" "git remote"
	"gra" "git remote add"
	"grao" "git remote add origin"
	"grau" "git remote add upstream"
	"grad" "git remote add dev"
	"gs" "git status"
	"gst" "git status --short --branch"
	# GHQ
	"gg" "ghq get"
	"gl" "ghq list | sort"
	"gt" "ls $GHQ_ROOT/github.com/*"
)
fi
# }}}
# Docker {{{
if (( $+commands[docker] )); then
_abbreviations+=(
	"di" "docker images"
	"dl" "docker ps -l -q"
	"dp" "docker ps"
	"dpa" "docker ps -a"
	"dr" "docker run"
	"drm" "docker rm"
	"drmi" "docker rmi"
	"ds" "docker start"
	"dd" "docker system prune -f"
	# Compose
	"dcb" "docker compose build"
	"dcp" "docker compose pull"
	"dcu" "docker compose up -d"
)
fi
# }}}

setopt extended_glob

__magic-abbrev-expand() {
	local MATCH

	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${_abbreviations[$MATCH]:-$MATCH}

	zle self-insert
}
zle -N __magic-abbrev-expand
bindkey -M viins " " __magic-abbrev-expand

__no-magic-abbrev-expand() {
	LBUFFER+=' '
}
zle -N __no-magic-abbrev-expand
bindkey -M viins "^x " __no-magic-abbrev-expand
# }}}
# Misc {{{
# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# Correctly display UTF-8 with combining characters.
if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
	setopt COMBINING_CHARS
fi

# Disable the log builtin, so we don't conflict with /usr/bin/log
disable log
# }}}
# Plugin {{{
local -A __plugins=()

# コマンド履歴検索
# Ctrl+R
__plugins+=("zdharma-continuum/history-search-multi-word" "history-search-multi-word.plugin.zsh")

# シンタックスハイライト
__plugins+=("zdharma-continuum/fast-syntax-highlighting" "fast-syntax-highlighting.plugin.zsh")

# 候補を表示
__plugins+=("zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh")

for repo file in ${(kv)__plugins}; do
	local f="$GHQ_ROOT/github.com/$repo/$file"
	[[ -f $f ]] && source $f
done

plugin-update() {
	for repo file in ${(kv)__plugins}; do
		ghq get -u $repo

		local p="$GHQ_ROOT/github.com/$repo/$file"
		if [[ $p -nt $p.zwc || ! -f $p.zwc  ]]; then
			zcompile "$p"
		fi
	done
}
# }}}
# Prompt {{{
autoload -Uz colors && colors

local COLOR_OFF="%{$reset_color%}"
local COLOR_0="%{$fg[black]%}"
local COLOR_1="%{$fg[red]%}"
local COLOR_2="%{$fg[green]%}"
local COLOR_3="%{$fg[yellow]%}"
local COLOR_4="%{$fg[blue]%}"
local COLOR_5="%{$fg[magenta]%}"
local COLOR_6="%{$fg[cyan]%}"
local COLOR_7="%{$fg[white]%}"
local COLOR_PATH=$'%{\e[38;5;244m%}%}'

local PROMPT_CHAR="❯"

# プロンプトで関数を使用できるように
setopt PROMPT_SUBST

PROMPT=$'\n'
PROMPT+='%(0?.${COLOR_2}.${COLOR_1})${PROMPT_CHAR}${COLOR_OFF} ' # 実行結果

# Hide old prompt
setopt TRANSIENT_RPROMPT

__pathshorten() {
	setopt localoptions noksharrays extendedglob
	local MATCH MBEGIN MEND
	local -a match mbegin mend
	echo "${1//(#m)[^\/]##\//${MATCH/(#b)([^.])*/$match[1]}/}"
}

RPROMPT=''
RPROMPT+='${COLOR_6}%n${COLOR_OFF}' # ユーザー名
RPROMPT+='${COLOR_7}@${COLOR_OFF}'
RPROMPT+='${COLOR_5}%m${COLOR_OFF}' # ホスト名
RPROMPT+='${COLOR_7}:${COLOR_OFF}'
RPROMPT+='${COLOR_PATH}$(__pathshorten "${PWD/$HOME/~}")${COLOR_OFF}' # ディレクトリ
# }}}
if [[ "~/.zshrc" -nt "~/.zshrc.zwc" || ! -f "~/.zshrc.zwc"  ]]; then
	zcompile ~/.zshrc
fi

if [[ -n $XDG_CACHE_HOME/zcompdump(#qN.mh+24) ]]; then
	compinit -d $XDG_CACHE_HOME/zcompdump
	if [[ "$XDG_CACHE_HOME/zcompdump" -nt "$XDG_CACHE_HOME/zcompdump.zwc" || ! -f "$XDG_CACHE_HOME/zcompdump.zwc" ]]; then
		zcompile $XDG_CACHE_HOME/zcompdump
	fi
else
	compinit -C -d $XDG_CACHE_HOME/zcompdump
fi

[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# bun completions
[ -s "/Users/ress/.bun/_bun" ] && source "/Users/ress/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
