JSON
================================================================

Ajax 処理では JSON を頻繁に使います

-  JSON
  - オブジェクトのシリアライズ形式の一種
  - JS のオブジェクトリテラルと一部互換性がある
- 注意点
  - コメントは書けない
  - Object のプロパティ名は `""` で囲む
  - Array や Object の末尾に `,` を書けない


OK
```json
'[1, 2, 3]'
'{"a": 1}'
```

NG
```json
'[1, 2, 3,]'
'{a: 1}'
'{a: 1,}'
'{"name": "hoge"}  // TODO: あとで直す'
```


## JS で JSON を扱う

- `window.JSON`
  - `JSON.stringify`:  オブジェクトを JSON 形式でシリアライズする
  - `JSON.parse`: JSON 文字列をパースして値を返す


```javascript
var obj = {
    foo : 1,
    bar : 2,
};
var str    = JSON.stringify(obj); // '{"foo":1,"bar":2}' (文字列)
var parsed = JSON.parse(str);     //  {foo: 1, bar: 2}   (Object)
```
