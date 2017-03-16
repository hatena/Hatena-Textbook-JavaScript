jQuery
================================================================

<img alt="Node.js logo" src="./jquery-logo.png" height="100"/>

* 世界的によく使われているライブラリ
* クロスブラウザ対応
* 便利機能なんでもあり
  * セレクタ、DOM操作、CSS、イベント、アニメーション、Ajax、リスト操作、……
* 最近はアンチ意見も多い


jQueryの使い方
----------------------------------------------------------------

### jQueryについて調べる

- 公式ドキュメント http://api.jquery.com/
- 他のサイトはできるだけ見ない！
  - jQuery周辺は古い情報が溢れてる


### jQueryを使う

- この講義ではCDNからロードします
  - 実際のサービスでは他のJSと結合して配信したり社内CDNを使ったりする

```html
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.0.min.js"></script>

<!-- 開発中はこちらのほうがデバッグが楽(圧縮されていない) -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.0.js"></script>
```

ロードしたらこのように使える。

```javascript
// window.jQuery または window.$ で参照できる
window.jQuery === window.$;  // true

// 文書読み込み完了時に関数を実行
$(function ($) { ... });

// CSS セレクタで要素を選択し、
// それらの要素が含まれる jQuery オブジェクトを作成
$('.foo');

// CSS セレクタで選択した要素のうち、最初の DOM オブジェクトを得る
$('.foo')[0];

// 以下は雰囲気は同じ
$('.foo').html();
$('.foo')[0].innerHTML;

// HTML 文字列から DOM 要素を作成し
// その要素をラップする jQuery オブジェクトを作成
var p  = $.parseHTML('<p>HTML fragment</p>');
var $p = $(p);
```


### jQueryオブジェクト

* `jQuery` 関数は `jQuery` オブジェクトを返す
* `jQuery` オブジェクトは何らかの要素のコレクション
  * 普通はDOMノード
  * 中身が0個のこともある
  * 中身はただのオブジェクトであることもある

```javascript
var obj = $({ name: "ababa" });
obj.on("click", (event) => {
    alert(event);
});
obj.trigger("click");  // alert が表示される
```


### DOM操作

jQueryオブジェクトはDOM操作の為のAPIを持つ。

- ページ内のh1タグのテキストを変更する

```javascript
$('h1').text('foo');
```

- ページ内のh1タグに画像を挿入する

```javascript
$('h1').append($('<img>').attr('src','http://〜〜'));
```

- DOM要素を直接参照することもできる

```javascript
$('div').eq(0).html() === $('div')[0].innerHTML;
```


### イベント処理

- イベント監視: `on`
  - 他にも色々あるけど、 `on` に統一するのが最近の主流  
- イベント発火: `trigger` `triggerHandler`
  - 自作オブジェクトに対しイベント発火するときは `triggerHandler` を使おう
  - 参考: [hitode909の日記](http://blog.sushi.money/entry/2013/11/24/174809)

```javascript
// foo クラスを持つ要素の click イベントを指定
// イベントを登録する要素は実行時点で存在したもののみ
$('.foo').on('click', (event) => { ... });

// 実行時点で存在したかに関わらず
// document 内の foo クラスを持つ全要素の click イベントを監視
$(document).on('click', '.foo', (event) => { ... });

// マウスが動いたらalert (うざい)
$(document).on('mousemove', () => alert('スクロールしました'));

// イベントを人工的に発火させることもできる
$(document).trigger('mousemove');
```


### jQueryを使ったページの初期化の流れ

+ ページが読まれたら
+ 何かセレクタで要素を集めて
+ イベントハンドラを設定

```javascript
// ページが読み込まれたときに
$(() => {
    alert('おはようございます');
});
```

```javascript
// ページ読み込み完了後、
$(() => {
    // p 要素がクリックされたら alert を表示する
    $('p').on('click', () => {
        alert('おはようございます');
    });
});
```

```javascript
// ページ読み込み完了後、
$(() => {
    // p 要素がクリックされたら、
    $('p').on('click', (e) => {
        // クリックされた p の内容を変更
        $(e.currentTarget).text('おはようございます');
    });
});
```

### Ajax

* jQueryにはAjax用のメソッドも入ってる
* ver 1.8よりPromiseベースに

#### $.ajax

```javascript
$.ajax({
    url    : '/entry',
    method : 'POST',
    data   : {
        userId : newEntry.userId,
        body   : newEntry.body,
    },
})
.then(() => {
    console.log('POST succeeded!');
});
```

#### $.get, $.post

`$.ajax` のエイリアス。

```javascript
$.get(url);
$.post(url, { body: 'foo' });
```


複雑な要素をページに挿入したい
----------------------------------------------------------------

- たとえば、ブログのエントリをJSで出したいとき、ブログのエントリをJSで組み立てるのは大変
- createElement + appendChildしまくってもできるけど読みにくい

```html
<div class="article">
  <div class="date"></div>
  <h1 class="title"></h1>
  <div class="body"></div>
  <div class="comments">
    <div class="comment"></div>
  </div>
</div>
```

```javascript
var $article = $('<div>').addClass('article');
$article.append($('<div>').addClass('date').text(date));
$article.append($('<h1>').addClass('title').text(title));
$article.append($('<div>').addClass('body').text(body));
$article.append($('<div>').addClass('comments'));
var $comments = $('<div>').addClass('comments');

for (var i = 0; i < comments.length; i++) {
    $comments.append($('<div>').addClass('comment'));
}

$article.append($comments);
$('.articles').append($article);
```

- テンプレートを使うときれいに書ける
  - underscore.jsの [`_.template`](http://underscorejs.org/#template) を使ったり
  - テンプレートリテラルを使ったり  

```javascript
// _.template を使う
var template = _.template($('.article-template').html());
$('.articles').append($(template({ article: article })));

// テンプレートリテラル
const renderArticle = (article) => `
  <div>
    <div class="title">${article.title}</div>
    <div class="body">${article.body}</div>
    ...
  </div>
`.trim();

var article = $.parseHTML(renderArticle(article));
$('.articles').append(article);
```

- サーバーサイドでHTMLを組み立ててから返してもよい
  - Template Toolkitを使う
