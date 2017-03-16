おまけ
================================================================

雑談
----------------------------------------------------------------

### JavaScriptはテストが難しい

- DOMと絡んだ動作のテストは難しい
  - イベント発火とモデルを切り離せると便利  
- 非同期な状態の変化をテストする必要がある
  - テストでもコールバックやPromiseを使う
- テストシナリオが複雑
  - 「ボタンを押して入力欄を開き、文章を入力してボタンを押すと、入力した値が表示されている」ことのテストとか
- ヘッドレスブラウザを使ったE2Eテスト
  - 画面に表示しないけど中でDOMを構築するブラウザ
  - PhantomJSなど
- ブラウザによって挙動がちがう
  - 手元でテストが通るけど特定の環境では動かないとか
  - IEのテスト用にはMicrosoftから仮想マシンが提供されている ([modern.ie](https://www.modern.ie/ja-jp))
  - クロスブラウザテストを行うサービスもある ([BrowserStack](https://www.browserstack.com/))
- 今回の課題では自動テストは不要です
  - あったらかっこいい


お役立ちサイト
----------------------------------------------------------------

* [JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript)
* [Can I use... Support tables for HTML5, CSS3, etc](http://caniuse.com/)


ブログ
----------------------------------------------------------------
* [JSer.info](http://jser.info/)
* [②ality – JavaScript and more](http://www.2ality.com/)
* [JS.next](http://js-next.hatenablog.com/)
