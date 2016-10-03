DOM
================================================================

```javascript
var source = document.getElementById('template').innerHTML;
```

* HTML ドキュメントの中身を操作しよう
* ブラウザの API を知ろう
  * jQuery 等ライブラリを使うと DOM を直接操作する機会は減るが、知っておく必要はある


## DOM とは

* Document Object Model の略
* HTML 文書を JS で操作する API を定めたもの
  * API: メソッドや定数といったインターフェイス


## DOM の基本的な考えかた

![](http://cdn-ak.f.st-hatena.com/images/fotolife/c/cho45/20100721/20100721183313.png)

* 木構造
  * 一番上には `document` ノード (文書ノード) がある


## DOM の仕様

* [DOM Standards](http://dom.spec.whatwg.org/) (WHATWG)
* [DOM 4](http://www.w3.org/TR/dom/) (W3C)

最近はここら辺。 ここらへんの文書がどうなってるのかややこしい。

* 通称 DOM Level 0 =  標準化されてなかったものの総称
  * DOM Level 0 の多くも HTML5 で標準化されている
* DOM Level 1 = とても基本的な部分 (Element がどーとか)
* DOM Level 2 = まともに使える DOM (Events とか)
* DOM Level 3 = いろいろあるが実装されてない


## DOM の構成要素

* `Node`
  * 多くの DOM の構成要素のベースインターフェイス
* `Element`
  * HTML の要素を表現する
* `Attr`
  * HTML の属性を表現する
* `Text`
  * HTML の地のテキストを表現する
* `Document`
  * HTML のドキュメントを表現する
* `DocumentFragment`
  * 文書木に属さない木の根を表現する

- `Element` も `Text` も `Node` のサブインターフェイス
- DOM 3 までは `Attr` も `Node` だったが DOM 4 では違う


## DOM API

よく使うメソッドだけ紹介

* `document.createElement('div')`
  * 要素ノードをつくる
* `document.createTextNode('text')`
  * テキストノードをつくる
* `element.appendChild(node)`
  * 要素に子ノードを追加する
* `element.removeChild(node)`
  * 要素の子ノードを削除する
* `document.querySelector('.foo')`
  * 指定したCSSセレクタにマッチする最初の要素を得る
* `document.querySelectorAll('.foo')`
  * 指定したCSSセレクタにマッチする要素を列挙
* `element.cloneNode(true);`
  * 指定したノードを子孫ノード込みで複製

参考: [DOM リファレンス - DOM | MDN](https://developer.mozilla.org/ja/docs/DOM/DOM_Reference)


## 例: テキストノードを要素に追加する

このようなページで
```html
<div id="container"></div>
```

次のスクリプトを実行する
```javascript
// `<div>foobar</div>` を作成
var elementNode = document.createElement('div');
var textNode    = document.createTextNode('foobar');
elementNode.appendChild(textNode);

// 文書木に追加
var containerNode = document.getElementById('container');
containerNode.appendChild(elementNode);
```

結果

```html
<div id="container">
  <div>foobar</div>
</div>
```

- ブラウザの画面に表示されるのは文書木 (document tree) に属するノード
  - ノードを作った段階では、そのノードはまだ文書木に属していない
  - 文章木に追加するとすぐに表示に反映される
