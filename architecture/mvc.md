MVC
================================================================

## 概要

<img style="background-color: white" src="./js-mvc-0.png"/>

* 処理を Model, View, Controller に分類
  * Model: ビジネスロジック全部
  * View: 見た目の処理
  * Controller: ユーザーの操作に応じて Model を呼び、更新する
* 元々は GUI プログラミングで発明された概念 <sup>[1](#foot-1)</sup>
* サーバーサイドの WAF でよく使われるアーキテクチャ <sup>[2](#foot-2)</sup>
  * Ruby on Rails, CakePHP など
  * クライアントサイドでは Ajax が絡んだりして、より複雑

* 代表的なフレームワーク
  * Backbone.js
  * Mithril


## ブックマーク一覧を MVC で

![](./js-mvc-2.png)


1. http://heim.ifi.uio.no/~trygver/themes/mvc/mvc-index.html <sup><a name="foot-1">^</a></sup>
2. サーバーサイドでの MVC とは本来の MVC とは異なり、 MVC2 などと呼ばれる <sup><a name="foot-2">^</a></sup>
