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
