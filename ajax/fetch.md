その他の方法
================================================================

## ライブラリ使う

- jQuery
- axios
- request
- superagent

などなど

jQueryについては後ほど解説します


## fetch

- XMLHttpRequest はなし崩し的に使われてきた
- WHATWG が新しい仕様を策定中
  - Promise ベースの API
  - `Headers` `Request` `Response` といったクラスを定義
  - 最近のブラウザだと使える
    - 2016-08-16 現在では Edge, Firefox, Chrome, Opera が対応
- 参考
  - [WHATWGによる仕様](https://fetch.spec.whatwg.org/)
  - [Fetch API 解説、または Web において "Fetch する" とは何か？ - Block Rockin’ Codes](http://jxck.hatenablog.com/entry/whatwg-fetch)


## fetch の使用例

```javascript
fetch(url)
    .then(res => res.text())    // .json() や .blob() もある
    .then(r => console.log(r));

// いろいろオプション書いたり
var headers = new Header();
fetch(url, {
    method  : 'POST',
    headers : headers,
    cache   : 'no-cache',
});

// 途中でキャンセルできる  
var fetching = fetch(url);
abortButton.addEventListener('click', () => {
    fetching.then(res => res.body.cancel());
});
```
