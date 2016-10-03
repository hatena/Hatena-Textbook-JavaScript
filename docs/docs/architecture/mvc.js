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

/**
 * Bookmark のコレクションクラス
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

const BOOKMARK_TEMPLATE = _.template(`
    <li class="bookmark">
      <p>url: <a href="<%- url %>"><%- url %></a></p>
      <time><%- getRelativeTime() %></time>
    </li>
`);

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
