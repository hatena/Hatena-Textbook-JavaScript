Promise
================================================================

## Promise

* ES2015で導入された
* `then` のメソッドチェインでコールバック関数をつなげられるようにする
  * 最近のjQueryでも使える

```javascript
$.get("http://example.com/aaa")
    .then((res) => {
        return JSON.parse(res.body);
    })
    .then((obj) => {
        // ...      
    });
```

さっきのコードはこうなる。ちょっと読みやすくなる。
```javascript
let db;
MongoClient.connect('mongodb://localhost:27017/rssDataBase')
    .then((_db) => {
        db = _db;
        return fs.readFile('./feed.xml', 'utf8');
    })
    .then(rssString => parseString(rssString))
    .then((result) => {
        const items = result.rss.channel[0].item;
        return Promise.all(items.map(item => request(item.link[0])));
    })
    .then((responses) => {
        return responses.map((res) => {
            return {
                url  : res.request.href,
                body : res.body,
            };
        });
    })
    .then((data) => {
        return db.collection('entries').insertMany(data);
    })
    .then(() => {
        db.close();
    });
```

使えるところではガンガン使っていこう。
