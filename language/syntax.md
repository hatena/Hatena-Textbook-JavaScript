構文
================================================================

JavaScriptのプログラムは、文と式で出来ている。


## [文](http://www.ecma-international.org/ecma-262/7.0/#sec-ecmascript-language-statements-and-declarations)

C言語やJavaあたりと似た文法。

* `{` `}` でブロックを作る
* 変数宣言 `var` `let` `const`
* 関数宣言 `function foo () {}`
* 条件文 `if` `else` `else if`
* ループ: `while` `for` `for-in`
  * `break` で抜けたり `continue` で次に進んだり
* try文: `try` `catch` `finally`
* etc...


## [式](http://www.ecma-international.org/ecma-262/7.0/#sec-ecmascript-language-expressions)

インタプリタに評価されて値を返すもの。

* リテラル: `123`, `'hello'`
* 識別子
* 関数式
* 関数呼び出し: `foo()`
* インスタンスの生成: `new Date()`
* etc...


## 演算子

基本的にはC言語やJavaと同じ。

* 四則演算系 `+`, `-`, `*`, `/`, `%`
* 代入 `=`, `+=`, `-=`, ...
* ビット演算 `&`, `|`, ...

以下、JS特有のもの。

* `typeof`
* `instanceof`
* `in`: オブジェクトがプロパティを持っているかどうか検査する
* `new`
* `delete`: プロパティの削除
* `===`, `!==`


## コメント

```javascript
// 一行コメント

/*
 * 複数行コメント
 */
```
