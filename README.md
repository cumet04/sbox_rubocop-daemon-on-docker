# sbox_rubocop-daemon-on-docker
rails (ruby) をdockerで動かす開発環境にてrubocop-daemonを快適に動かす試みです。

サンプルとしてRailsが入っていますが特にRailsには依存しておらず、アイデアは他でも使えるはずです。

## 動作環境
以下の環境に依存します:
- Docker / docker-compose
- ncコマンド (netcat)
- (vscode & ruby extension)

`backend/bin/rubocop`の中のvscode依存の決め打ちを修正すれば、普通のrubocop-daemon-wrapperとして使えます。

## 起動・動作確認

### ncコマンドを調整する
`backend/bin/rubocop`内で定義している`NETCAT`変数の値を、実行環境に応じて書き換えます。

[オリジナルのrubocop-daemon-wrapper](https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper)を見るに「macを含む普通は`"nc"`のみ、fedora以外のlinuxは`"nc -N"`」のようです。

### `backend/bin/rubocop`にPATHを通してvscodeを起動する
※rubocopをformatterとして使いたい場合のみです。linterのみでよければ普通に起動でok

[rubocop-daemonのREADME](https://github.com/fohte/rubocop-daemon#use-with-vs-code)にもあるように、vscodeで使う場合には`rubocop`を実行すると本スクリプトが起動する状態にしておく必要があります。

#### 方法1 `backend/bin`をPATHに追加して起動する
```bash
$ env PATH="$PWD/backend/bin:$PATH" code .app.code-workspace
```

PATHの先頭に`backend/bin`を追加してvscodeを起動します。shellから起動する必要がありますが、PCのグローバル環境を汚染しません。

#### 方法2 `backend/bin/rubocop`をPATHの通ったところにシンボリックリンクしておく
```bash
$ ln -s $PWD/backend/bin/rubocop /usr/local/bin
$ code .app.code-workspace
```

グローバルに配置します。配置先は自身のPATHの優先度を確認し良いところにします。

vscodeをshellから起動せずにすみますが、プロジェクト固有のものをグローバルに配置してしまいます。  
1マシンで複数プロジェクトを扱う場合には採用できません。

### 開発環境を起動・rubocopする
docker-composeを起動します; `docker-compose up`

vscodeのruby extensionの設定にて
- ruby.formatやruby.lintがrubocop
- `"ruby.useBundler": false`

となっていれば、vscodeのformatやlintなどで高速にrubocopが実行されます。
