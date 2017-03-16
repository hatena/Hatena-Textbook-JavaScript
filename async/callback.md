コールバックによる非同期処理
================================================================

GETリクエストを送信して結果を表示。

Perlだと同期的に処理するが。
```perl
my $ua = LWP::UserAgent->new;
my $res = $ua->request(GET $url); # ここでブロック(待たされる)
print($res->content);
```

JavaScriptだとこうなる。
```javascript
$.get(url, (res) => {
    console.log(res);
});
```

- 通信中はブロックせず、この下に書かれたコードが実行される
- 通信終了したらコールバックが呼び出される

JavaScriptでは、さまざまな処理でコールバックを利用する。

例: ラーメンタイマー。
```javascript
// 180秒後にalertする
setTimeout(() => {
    alert('ラーメンできたよ！');
}, 180 * 1000);
```


## コールバック地獄

コールバックを利用する処理が重なると、どんどんネストが深くなっていき、読みづらいコードになる。

```javascript
MongoClient.connect('mongodb://localhost:27017/rssDataBase', (err, db) => {
    fs.readFile('./feed.xml', 'utf8', (err, rssString) => {
        parseString(rssString, (err, result) => {
            const items = result.rss.channel[0].item;
            const data  = [];
            items.forEach((item) => {
                request(item.link[0], (err, res) => {
                    data.push({
                        url  : res.request.href,
                        body : res.body,
                    });
                    if (data.length === items.length) {
                        db.collection('entries').insertMany(data, (err, result) => {
                            db.close();
                        });
                    }
                });
            });
        });
    });
});
```
