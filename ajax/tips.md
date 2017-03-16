Ajax Tips
================================================================

## Ajaxのデバッグ

デベロッパーツールのNetworkタブで通信内容を見よう。

- リクエストヘッダ、レスポンスヘッダ
- レスポンス内容
- サイズ
- 通信時間


## Same-Origin Policy

[同一オリジンポリシー - Web セキュリティ | MDN](https://developer.mozilla.org/ja/docs/Web/Security/Same-origin_policy)

- 基本的に、他ドメインのリソースは読み込めない
  - `b.hatena.ne.jp` からは `b.hatena.ne.jp` のリソースだけ読み込める
  - `d.hatena.ne.jp` のデータをJSで読み込んだり表示したりは出来ない  
- iframeは別ドメインのページを表示できるが、その中身をJSで操作したりは出来ない


## CORS

サーバー側で `Allow-Access-Control-Origin` ヘッダを設定すると、他のドメインから参照できるようになる。

```
Access-Control-Allow-Origin: http://b.hatena.ne.jp
```

公開APIの場合はワイルドカードが使える。
```
Access-Control-Allow-Origin: *
```

- 独自ヘッダーをつける時やクッキーを使う時は追加でヘッダが必要
  - 参考: [HTTP アクセス制御 (CORS) - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/HTTP_access_control)
