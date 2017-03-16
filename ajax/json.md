JSON
================================================================

Ajax処理ではJSONを頻繁に使います。

-  JSON
  - オブジェクトのシリアライズ形式の一種
  - JSのオブジェクトリテラルと一部互換性がある
- 注意点
  - コメントは書けない
  - Objectのプロパティ名は `""` で囲む
  - ArrayやObjectの末尾に `,` を書けない


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


## JSでJSONを扱う

- `window.JSON`
  - `JSON.stringify`:  オブジェクトをJSON形式でシリアライズする
  - `JSON.parse`: JSON文字列をパースして値を返す


```javascript
var obj = {
    foo : 1,
    bar : 2,
};
var str    = JSON.stringify(obj); // '{"foo":1,"bar":2}' (文字列)
var parsed = JSON.parse(str);     //  {foo: 1, bar: 2}   (Object)
```
