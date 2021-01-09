# sbox_rubocop-daemon-on-docker
rails (ruby) をdockerで動かす開発環境にてrubocop-daemonを快適に動かす試みです。

サンプルとしてRailsが入っていますが特にRailsには依存しておらず、アイデアは他でも使えるはずです。

## 動作環境
以下の環境に依存します:
- Docker / docker-compose
- ncコマンド (netcat)
- (vscode & ruby extension & ruby-rubocop extension)

`backend/bin/rubocop`の中のvscode依存の決め打ちを修正すれば、普通のrubocop-daemon-wrapperとして使えます。

## 起動・動作確認

### ncコマンドを調整する
`backend/bin/rubocop`内で定義している`NETCAT`変数の値を、実行環境に応じて書き換えます。

[オリジナルのrubocop-daemon-wrapper](https://github.com/fohte/rubocop-daemon/blob/master/bin/rubocop-daemon-wrapper)を見るに「macを含む普通は`"nc"`のみ、fedora以外のlinuxは`"nc -N"`」のようです。

### 開発環境を起動・rubocopする
docker-composeを起動します; `docker-compose up`

vscodeでformatterとして使う場合は、`misogi.ruby-rubocop` extensionを導入し`.vscode/settings.json`を参考に設定してください。

[rubocop-daemonのREADME](https://github.com/fohte/rubocop-daemon#use-with-vs-code)にもあるように、ruby extensionではruby formatterのカスタムパスを設定できないため、その設定ができる外部拡張に頼る必要があります。

※rubocopをformatterとして使いたい場合のみです。linterのみでよければ普通に起動でok
