# 補完機能

# 補完機能の強化

#補完に関するオプション
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

setopt print_eight_bit       # 日本語ファイル名等8ビットを通す
setopt extended_glob         # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots              # 明確なドットの指定なしで.から始まるファイルをマッチ

setopt list_packed           # リストを詰めて表示

# cdを使わずにディレクトリを移動できる
setopt auto_cd

# "cd -"の段階でTabを押すと、ディレクトリの履歴が見れる
setopt auto_pushd

# 補完候補を ←↓↑→ でも選択出来るようにする
zstyle ':completion:*:default' menu select=2

# 補完関数の表示を過剰にする編
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'

# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補正機能

setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"

# prompt

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz is-at-least

# begin VCS

zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true
zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
  zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
  zstyle ":vcs_info:git:*" stagedstr "<S>"
  zstyle ":vcs_info:git:*" unstagedstr "<U>"
  zstyle ":vcs_info:git:*" formats "(%b) %c%u"
  zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function _update_vcs_info_msg() {
  psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

RPROMPT="[$BLUE%~%f$DEFAULT%1(v|%F{green}%1v%f|)]"
add-zsh-hook precmd _update_vcs_info_msg

# alias

alias lst='ls -ltr --color=auto'
alias l='ls -ltr --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias vz='vim ~/.zshrc'
alias up='sudo apt update -y && sudo apt upgrade -y'
alias rs='source ~/.zshrc'
alias h='fc -lt '%F %T' 1' # historyに日付を表示
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias tgz='tar -xzvf'
alias g='git'
alias we='explorer.exe'
alias tm='time ( zsh -i -c exit )'
alias cl="richpager -s native"

# zplug

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "peco/peco", as:command, from:gh-r
zplug "b4b4r07/dotfiles", as:command, use:bin/peco-tmux
zplug "b4b4r07/enhancd", use:init.sh, on:"junegunn/fzf-bin"
zplug "supercrabtree/k"
zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq
zplug "b4b4r07/emoji-cli", \
    on:"stedolan/jq"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug 'danihodovic/steeef', as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load #--verbose

# anyenv

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - --no-rehash)"

# history

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zhistory

# メモリに保存される履歴の件数
export HISTSIZE=10000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=10000000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# path

if [ -e $HOME/path ]; then
  export PATH="$PATH:$HOME/path"
fi

export PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-linux
export PATH=$PATH:$HOME/.cargo/bin
export GPG_TTY=$(tty)

if (which zprof > /dev/null 2>&1) ;then
  zprof
  # zprof | cl
fi
