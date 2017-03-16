jQueryでのページ設計
================================================================

- jQueryで処理を書く場合、1つの関数にベタッと書きがち
- 問題点
  - 読めないコードになる
  - テストが難しい

[MVC の章](./mvc.md)で挙げたブックマークページの例。

```javascript
(function () {
    var $bookmarks    = $('.bookmark-container');
    var $bookmarkList = $bookmarks.find('.bookmark-list');

    // ブックマーク入力フォーム
    var $bookmarkInput  = $bookmarks.find('.bookmark-input');
    var $bookmarkButton = $bookmarks.find('.bookmark-button');

    var bookmarkTemplate = _.template('<li><%- body %></li>');

    // イベントリスナ登録
    $bookmarkButton.on('click', () => {
        const $bookmark = $.parseHTML(bookmarkTemplate({
            body : $bookmarkInput.val(),  
        }))
        $bookmarkList.append($bookmark);
    });

    // ...
})();
```

本項では、上記のコードをリファクタしつつMVP / MVCパターンを紹介する。


## まずは構造化

初期化とそれ以外を分離。

* 初期化
  * 必要なDOM要素の取得
  * データの初期化
  * イベントリスナーの登録
* それ以外
  * イベントリスナー
  * データの更新処理

```javascript
const BOOKMARK_TEMPLATE = _.template('<li><%- url %></li>');

class BookmarkPage {

    constructor ($element) {
        // 要素の取得
        this.$element        = $element;
        this.$bookmarkList   = $element.find('.bookmark-list');
        this.$bookmarkUrl    = $element.find('.bookmark-url');
        this.$bookmarkButton = $element.find('.bookmark-button');

        // イベントリスナーの登録
        $bookmarkButton.on('click', () => this.addNewBookmark());
    }

    // イベントリスナー
    addNewBookmark () {
        const url = this.$bookmarkUrlInput.text();

        const $bookmark = $.parseHTML(BOOKMARK_TEMPLATE({ url : url }));
        this.$bookmarkList.append($bookmark);
    }

}

(function () {
    const bookmarkPage = new BookmarkPage($('.bookmark-container'));
})();
```


## Modelの作成

複雑になるとModelが出来たりする。

- User, Diary, EntryといったEntityクラスとか
- サーバへのアクセスをラップしてくれるServiceっぽいとか

以下はブックマーク1件を表すクラスの例。

```javascript
/**
 * Bookmark のモデルクラス
 */
class Bookmark {

    /**
     * @param {String} url
     * @param {Date} created
     */  
    constructor (opts) {
        this.url      = opts.url;
        this.created  = opts.created;
    }

    /**
     * "n 分前" みたいな形式でブックマークした時刻を表示する
     * @return {String}
     */
    getRelativeTime () {
        return moment(this.created).fromNow();
    }

}
```

## そしてMVPへ

- jQueryベタ書きから移行するにはMVPの方が楽 (私見)
  - Modelの変更をViewに反映するのが難しい

MVPでは、 PresenterがModelの更新を明示的にViewに反映します。

```javascript
const BOOKMARK_TEMPLATE = _.template(`
    <li class="bookmark">
      <p>url: <a href="<%- url %>"><%- url %></a></p>
      <time><%- getRelativeTime() %></time>
    </li>
`);

class BookmarkView {

    constructor ($element) {
        this.$element        = $element;
        this.$bookmarkList   = $element.find('.bookmark-list');
        this.$bookmarkUrl    = $element.find('.bookmark-url');
        this.$bookmarkButton = $element.find('.bookmark-button');

        // ユーザー入力を加工してイベントを発火
        this.$bookmarkButton.on('click', () => {
            const url = this.$bookmarkUrl.val();
            $(this).triggerHandler('addNewBookmark', url);
        });
    }

    /**
     * @param {Array<Bookmark>} bookmarks
     */
    render (bookmarks) {
        this.$bookmarkList.empty();
        bookmarks.forEach((bookmark) => {
            const html      = BOOKMARK_TEMPLATE(bookmark);
            const $bookmark = $.parseHTML(html);
            this.$bookmarkList.append($bookmark);
        });
    }

}

class BookmarksPresenter {

    /**
     * Model と View を初期化
     * View からユーザーのイベントを受け取る
     * Model を更新したら View に反映する
     */
    constructor ($element) {
        this.bookmarks = [];
        this.view      = new BookmarkView($element, this.bookmarks);
        $(this.view).on('addNewBookmark', (e, url) => this.addNewBookmark(url));
    }

    /**
     * ユーザー入力を元に Model を更新し、 View に反映する
     */
    addNewBookmark (url) {
        const bookmark = new Bookmark({
            url     : url,
            created : new Date(),
        });
        this.bookmarks.push(bookmark);
        this.view.render(this.bookmarks);
    }

}

$(function(){
    const presenter = new BookmarksPresenter($('.bookmarks'));
});
```

- codepenにサンプルコード置きました
  - http://codepen.io/anon/pen/zBbQYW


## jQueryだけでMVC

- MVCの場合、柔軟なイベントシステムが欲しくなる
  - 大抵のMV* フレームワークはイベント機能を搭載している
- DOMを自分で操作するのが大変
  - リストの一部を更新する場合など

以下、 jQueryだけで簡単なMVC構成を試してみます。


### コレクションクラスの作成

- ブックマーク一覧の変更を監視するため、Bookmarkの集合のクラスを作る
  - `$(this)` でイベントを発行

```javascript
/**
 * Bookmark のコレクション
 * Bookmark 一覧に変化があったら 'change' イベントを発火する
 */
class Bookmarks {

    constructor () {
        this.bookmarks = [];
    }

    /**
     * @param {Bookmark} bookmark
     */
    push (bookmark) {
        this.bookmarks.push(bookmark);
        $(this).trigger('change');
    }

    /**
     * @param {function} callback
     */
    forEach (callback) {
        this.bookmarks.forEach(callback);
    }

}
```

続いてView, Controllerを作成。

- イベントによってM, V, C間を疎結合に
  - ControllerがViewのイベントを監視
  - ViewがModelのイベントを監視
- 複雑になったときにテストしやすくなる
  - とはいえ、この実装はすごく冗長
  - 大抵の場合は何らかのフレームワークを使う

```javascript
class BookmarkView {

    constructor ($element, bookmarks) {
        this.$element        = $element;
        this.$bookmarkList   = $element.find('.bookmark-list');
        this.$bookmarkUrl    = $element.find('.bookmark-url');
        this.$bookmarkButton = $element.find('.bookmark-button');

        // ユーザー入力を加工してイベントを発火
        this.$bookmarkButton.on('click', () => {
            const url = this.$bookmarkUrl.val();
            $(this).triggerHandler('addNewBookmark', url);
        });

        // Model の変更を監視して表示を更新する
        this.bookmarks = bookmarks;
        $(this.bookmarks).on('change', () => this.render());
    }

    render () {
        this.$bookmarkList.empty();
        this.bookmarks.forEach((bookmark) => {
            const html      = BOOKMARK_TEMPLATE(bookmark);
            const $bookmark = $.parseHTML(html);
            this.$bookmarkList.append($bookmark);
        });
    }

}

class BookmarksController {

    /**
     * Model と View を初期化
     * View からユーザーのイベントを受け取る
     */
    constructor ($element) {
        this.bookmarks = new Bookmarks();
        this.view      = new BookmarkView($element, this.bookmarks);
        $(this.view).on('addNewBookmark', (e, url) => this.addNewBookmark(url));
    }

    /**
     * ユーザー入力を元に Model を更新する
     */
    addNewBookmark (url) {
        const bookmark = new Bookmark({
            url     : url,
            created : new Date(),
        });
        this.bookmarks.push(bookmark);
    }

}

$(function(){
    const controller = new BookmarksController($('.bookmarks'));
});
```

- codepenにサンプルコード置きました
  - http://codepen.io/anon/pen/AXwkOa
