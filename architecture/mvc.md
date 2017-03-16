MVC
================================================================

## 概要

<img style="background-color: white" src="./js-mvc-0.png"/>

* 処理をModel, View, Controllerに分類
  * Model: ビジネスロジック全部
  * View: 見た目の処理
  * Controller: ユーザーの操作に応じてModelを呼び、更新する
* 元々はGUIプログラミングで発明された概念 <sup>[1](#foot-1)</sup>
* サーバーサイドのWAFでよく使われるアーキテクチャ <sup>[2](#foot-2)</sup>
  * Ruby on Rails, CakePHPなど
  * クライアントサイドではAjaxが絡んだりして、より複雑

* 代表的なフレームワーク
  * Backbone.js
  * Mithril


## ブックマーク一覧をMVCで

![](./js-mvc-2.png)


1. http://heim.ifi.uio.no/~trygver/themes/mvc/mvc-index.html <sup><a name="foot-1">^</a></sup>
2. サーバーサイドでのMVCとは本来のMVCとは異なり、 MVC2などと呼ばれる <sup><a name="foot-2">^</a></sup>
