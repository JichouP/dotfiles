# -------------------------------------
# 補完機能
# -------------------------------------

# 補完機能の強化
autoload -U compinit
compinit

[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
  [[ -n "$ATTACH_ONLY" ]] && {
    tmux a 2>/dev/null || {
      cd && exec tmux
    }
    exit
  }

  tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
    exec tmux
}

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

  bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

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

#LS_COLORSを設定しておく
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#ファイル補完候補に色を付ける
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# -------------------------------------
# 補正機能
# -------------------------------------
## 入力しているコマンド名が間違っている場合にもしかして：を出す。
  setopt correct
  SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"
# -------------------------------------
# プロンプト
# -------------------------------------

  autoload -Uz add-zsh-hook
# autoload -U promptinit; promptinit
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

# end VCS

# PROMPT="$GREEN%m$DEFAULT:$CYAN%n$DEFAULT%% "
  PROMPT="%B$GREEN%n$DEFAULT%b@%B$CYAN%m$DEFAULT%b "

  function _update_vcs_info_msg() {
    psvar=()
      LANG=en_US.UTF-8 vcs_info
      [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  }

RPROMPT="["
RPROMPT+="$BLUE%~%f$DEFAULT"
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT+="%1(v|%F{green}%1v%f|)"
RPROMPT+="]"

# グローバルエイリアス
alias -g L='| less'
alias -g H='| head'
alias -g G='| grep'
alias -g GI='| grep -ri'


# エイリアス
alias lst='ls -ltr --color=auto'
alias l='ls -ltr --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias so='source'
alias v='vim'
alias vi='vim'
alias vz='vim ~/.zshrc'
alias c='cdr'
alias phpstart='php -S localhost:3000'
alias up='sudo apt update -y && sudo apt upgrade -y'
alias mg='mongod --config /etc/mongod.conf'
alias rs='source ~/.zshrc'

# historyに日付を表示
alias h='fc -lt '%F %T' 1'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'
alias tgz='tar -xzvf'
alias gb='gatsby develop --port 3000'
alias y='y'
alias yw='yarn watch'
alias ys='yarn start'
alias yb='yarn build'
alias g='git'
alias we='explorer.exe'

# -------------------------------------
# zgen
# -------------------------------------
source ~/.zgen/zgen.zsh

if ! zgen saved; then
zgen load zsh-users/zsh-completions
zgen load zsh-users/zsh-syntax-highlighting
zgen load mollifier/anyframe
zgen load supercrabtree/k
zgen load b4b4r07/enhancd

# pure
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure

zgen save
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
zgen prezto
prompt steeef
PURE_PROMPT_SYMBOL=">"


# cdを使わずにディレクトリを移動できる
setopt auto_cd
# "cd -"の段階でTabを押すと、ディレクトリの履歴が見れる
setopt auto_pushd

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
export PATH="$PATH:$HOME/s"
