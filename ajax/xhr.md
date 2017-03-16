XMLHttpRequest
================================================================

- IE5で導入され、後に標準化された
- Ajax用ライブラリは皆XMLHttpRequestのラッパー
  - 細かい制御をしようとすると直接さわる必要がある


## 生 `XMLHttpRequest` のようす

生で使うことは滅多にないが、一応雰囲気だけ知っておこう。

```javascript
// リクエストのオブジェクトを作成
var xhr = new XMLHttpRequest();
xhr.open('GET', '/api/foo', true);

// レスポンスが返ってきたときの処理を登録
xhr.onreadystatechange = (e) => {
    if (xhr.readyState == 4) {
        if (xhr.status == 200) {
            console.log(xhr.responseText);
        }
        else {
            console.log('error');
        }
    }
};

// リクエストを送信
xhr.send(null);
```

POSTの場合。

```javascript
var xhr = new XMLHttpRequest();
xhr.open('POST', '/api/foo', true);
xhr.onreadystatechange = (e) => { ... };

// クエリパラメータをつくる
var params = { a: 1, b: 'Hi there' };
var pairs = Object.keys(data).map((key) => {
    return `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`;
});
var data = pairs.join('&');  // data === 'a=1&b=Hi%20there'

xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
xhr.send(data);
```
