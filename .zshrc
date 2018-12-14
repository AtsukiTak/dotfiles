#
# 基本
#
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.go/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
export CPATH=/usr/local/opt/openssl/include:/usr/local/include:$CPATH
export GOPATH=$HOME/.go
export fpath=($HOME/.zfunctions $fpath)

# 文字コードはUTF-8
export LANG=ja_JP.UTF-8

# less コマンドに色をつける
export LESS=-iMR
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

#Pure prompt
autoload -U promptinit; promptinit
prompt pure


# コマンドのスペルミスを指摘
setopt correct

# ディレクトリ名でcd
setopt auto_cd

# ビープ音を鳴らさない
#setopt no_beep

#alias
alias t="tree"
alias mv='mv -i'
alias l='ls -1'
alias python='python3'
alias bitcoin-cli='~/Develop/bitcoin/bitcoin-core/src/bitcoin-cli -rpcconnect=10.0.1.5 -rpcport=8332 -rpcuser=gacky -rpcpassword=bitcoinwithgacky'

#
# 補完
#
autoload -Uz compinit
compinit -u

# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

# 候補が多い場合は詰めて表示
setopt list_packed

# コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt magic_equal_subst

# 大文字小文字を区別しない（大文字を入力した場合は区別する）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

# auto_pushdで重複するディレクトリは記録しない
setopt pushd_ignore_dups


#
# 履歴
#
HISTFILE=~/.zsh_history

# メモリ上に保存される件数（検索できる件数）
HISTSIZE=100000

# ファイルに保存される件数
SAVEHIST=100000

# rootは履歴を残さないようにする
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

# 履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 履歴を複数の端末で共有する
# setopt share_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# 重複するコマンドは古い方を削除する
setopt hist_ignore_all_dups

# 複数のzshを同時に使用した際に履歴ファイルを上書きせず追加する
#setopt append_history

# 履歴ファイルにzsh の開始・終了時刻を記録する
#setopt extended_history

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
#setopt hist_verify

# 先頭がスペースで始まる場合は履歴に追加しない
#setopt hist_ignore_space

# ファイルに書き出すとき古いコマンドと同じなら無視
#setopt hist_save_no_dups


#
# 色
#
# autoload colors
# colors

# # プロンプト
# PROMPT="%{${fg[green]}%}
# 
# %n %{${fg[yellow]}%}%~
# %{${fg[red]}%}%# %{${reset_color}%}"
# PROMPT2="%{${fg[yellow]}%} %_ > %{${reset_color}%}"
# SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"

# ls
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# lsがカラー表示になるようエイリアスを設定
case "${OSTYPE}" in
darwin*)
  # Mac
  alias ls="ls -GF"
  ;;
linux*)
  # Linux
  alias ls='ls -F --color'
  ;;
esac


# screen用設定

case "${TERM}" in
    screen-256color*)
        preexec()
        {
            echo -ne "\ek${1%% 2%% *}\e\\"
        }
        precmd()
        {
            echo -ne "\ek$(basename $SHELL)\e\\"
        }
        ;;
esac

#
# その他
#

#centosにsshするとviで下記のエラーが出ることがあるので対策
# E437: terminal capability "cm" required
alias ssh='TERM=xterm ssh'

#[[ -s /Users/takahashiatsuki/.rsvm/rsvm.sh ]] && . /Users/takahashiatsuki/.rsvm/rsvm.sh # This loads RSVM
