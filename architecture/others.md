その他のアーキテクチャ
================================================================

有名どころについて、概要だけ紹介


## MVVM

[![MVVMの概念図](https://upload.wikimedia.org/wikipedia/commons/8/87/MVVMPattern.png)](https://ja.wikipedia.org/wiki/Model_View_ViewModel)

* 処理を Model, View, ViewModel に分類
* ViewModel
  * Model
  * Presenter との違い
    * View を明示的に更新しない
    * フレームワーク等により、 View が自動で更新される  
* 代表的なフレームワーク
  * Vue.js
  * Knockout.js


## MVP

[![](http://cdn-ak.f.st-hatena.com/images/fotolife/n/nanto_vi/20150207/20150207142855.png)](http://developer.hatenastaff.com/entry/2015/02/13/121217)

* 処理を Model, View, Presenter に分類
* Presenter
  * ユーザー入力を受け取り、Model を変更し、View を更新する
  * View の操作も行う Controller みたいなもの


## Flux

[![Fluxの概念図](https://facebook.github.io/flux/img/flux-simple-f8-diagram-with-client-action-1300w.png)](https://facebook.github.io/flux/docs/overview.html)

* コンポーネント間の結合を薄くするため、グローバルなイベントを利用する
  * Observer パターンの一種
* 代表的なフレームワーク
  * Redux
  * Fluxible
