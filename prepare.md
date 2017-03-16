予備知識
================================================================

JavaScriptとは。

* 基本的にはブラウザ上の処理
  * Webアプリケーションにはほぼ必須
  * はてなのエンジニアは皆ある程度書ける
* 最近では色んな所で使われている
  * サーバーサイド (Node.js)
  * npm, gulpなどの開発ツール (Node.js)
  * デスクトップアプリ (Electron)
  * スマホアプリ (Windows Phone, React Native, Titanium等)

今回は基本的にブラウザ上で動作するJSを対象にします。


## JS、HTML、CSSについて調べるときに困ること

* ブラウザ、処理系によって違う部分が多い
* 変化が激しい
  * 一年前の情報がアテにならないことも
* 誤った情報や、参考にすべきでない情報もある

そのため、読者諸君は。

* 基礎的な知識を身につける
* 信頼できる情報を探せるようになる
* 信頼できるサイトを見つけておく

ことを心がけよう。


## クロスブラウザについて

* 多くの処理系があるので、あらゆる環境に対応するのは難しい
  * クロスブラウザ対応はバッドノウハウの塊みたいなもの
  * 本質的ではない

本講義では最新のFirefoxやChromeを使って開発することを前提とする。


## デバッグ方法

* 事前課題のJS-0で開発ツール使えた？
* いま適当なページで開発ツールを使ってみよう
  * HTML構造を見る、適用されているCSSを見る
  * コンソール上でJSを実行 (`document.body.innerHTML = ""`)
* スクリプトを中断する場所 (ブレークポイント) を指定し、そこから1行ずつ実行できる
  * スクリプト中に `debugger;` と書いておけばそこで中断する


### printデバッグ

値を出力して確認する方法。

* `console.log()`
  * オブジェクトの中身まで見れて便利
  * 本講義では基本的にこれを使う
* `alert()`
  * 古典的だが今でも役に立つ
  * その時点で処理がブロックするので、ステップをひとつずつ確認するとき便利
  * スマートフォンや携帯ゲーム機などデバッガが無い場合


### スマートフォンの場合

iOS, Androidのブラウザは、 PCにつないでリモートデバッグできる。

* iOSのSafari
  * mac上のSafariでデバッグ
  * [Safari Developer Library](https://developer.apple.com/library/safari/documentation/AppleApplications/Conceptual/Safari_Developer_Guide/GettingStarted/GettingStarted.html#//apple_ref/doc/uid/TP40007874-CH2-SW8)
* AndroidのChrome
  * PCのChromeでデバッグ
  * [Remote Debugging Android Devices | Web Tools - Google Developers](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/remote-debugging)
