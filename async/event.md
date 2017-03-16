イベント
================================================================

## イベントドリブン

ブラウザからのイベントで処理を進める方式。

* 😇 イベント発火まではCPUを食わない
* 👿 コールバックを多用するので読みにくいかも
* 👿 1つ1つの処理を小さくしないと、全部止まる
  * ブラウザの表示処理まで止まる


## DOMイベントの例

- click
- dblclick
- mousedown
- mousemove
- keydown
- load
- etc...

参考: [DOM イベントリファレンス | MDN](https://developer.mozilla.org/ja/docs/Web2/Reference/Events)


## `addEventListener`

* `element.addEventListener(eventName, callback, useCapture)`
  * ある要素のあるイベントに対してコールバックを設定する

```javascript
document.body.addEventListener('click', function (e) {
    alert('clicked!');
}, false);
```

参考: [EventTarget.addEventListener - Web API インターフェイス | MDN](https://developer.mozilla.org/ja/DOM/element.addEventListener)


## DOMイベントのイベントバブリング

```html
<p id="outer">Hello, <span id="inner">world</span>!</p>
```

- `inner` をクリックするとき、`outer` もクリックされている
- イベントは実際に発生したノードから親に向かって浮上 (バブル) していく
  - 一部、バブリングしないイベントもある (`focus` `load` etc...)

[<img src="https://www.w3.org/TR/DOM-Level-3-Events/images/eventflow.svg" width="400"/>](https://www.w3.org/TR/DOM-Level-3-Events/#event-flow)


## ページ読み込み時のイベント

* `DOMContentLoaded` イベント
  * DOMの構築が終わったあとに発生
  * このイベント発生前にDOMをいじると壊れるので注意
* `load` イベント
  * 画像など、ページ内のリソースを全部ロードしたら発生

初期化は次のように書くことが多い。
```javascript
document.addEventListener('DOMContentLoaded', function (e) {
    var elem = document.getElementById("...");
    // ...
});
```


## イベントオブジェクトの構成要素

```javascript
document.body.addEventListener('click', function (e) {
    alert(e.target);
});
```

コールバックに渡されるオブジェクト。

- `target` : イベントのターゲット (クリックされた要素)
- `clientX`, `clientY` : クリックされた場所の座標
- `stopPropagation()` : イベントの伝播 (含むバブリング) をとめる
- `preventDefault()` : イベントのデフォルトアクションをキャンセルする
  -  デフォルトアクション : リンクのクリックイベントなら、「リンク先のページへ移動」

参考: [​event - Web API インターフェイス | MDN​](https://developer.mozilla.org/ja/docs/Web/API/Event)


## オブジェクトのメソッドをイベントハンドラとして使う

- `this` が指す内容に注意
  - Arrow Functionを使えば大体問題ない

```javascript
class Notifier {
    constructor (element, message) {
        this.message = message;

        // NG
        // `this` は `undefined` であり、エラーになる
        element.addEventListener('click', function () {
            this.notify();
        });  

        // NG
        element.addEventListener('click', this.notify);

        // OK
        // `self` インスタンスへの参照を保持
        var self = this;
        element.addEventListener('click', function () {
            self.notify();
        });  

        // OK
        // Arrow Function は自動的に `this` が bind される
        element.addEventListener('click', () => {
            this.notify();
        });  
    }
    notify () {
        console.log(this.message);       
    }    
}

new Notifier(document.body, 'Clicked!');
```
