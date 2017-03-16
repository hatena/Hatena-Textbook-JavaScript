型と値
================================================================

* 変数には型はない
* 値には型がある
  * プリミティブ値 + オブジェクト型
* 関数も値 (オブジェクト)


## 変数には型がない

同じ変数にいろんな型の値を代入できます。

```javascript
var foo = "";  // 文字列
foo = 1;       // 数値も入る
foo = {};      // オブジェクトも入る
```


## 値の型

Rubyと違い「すべての値はオブジェクト」ではない。

* プリミティブ値
  * Undefined型
  * Null型
  * Boolean型
  * Number型
  * Symbol型
  * String型
* Object型


## [プリミティブ値とリテラル](http://www.ecma-international.org/ecma-262/7.0/#sec-primitive-value)

参考: [文法とデータ型 - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Guide/Grammar_and_types#Data_structures_and_types)

### 文字列 (String型)

* 文字列はUTF-16で表現される
* 3種類のリテラル

```javascript
var str1 = "`\\n` などのエスケープシーケンスが使える\n(改行)";
var str2 = 'シングルクオートで囲むこともできる。 基本的にはダブルクオートと同じ。';

var str3 = `ES2015で追加された、テンプレートリテラル`;
var str4 = `${'この' + '様に'} 式を埋め込んだり、
改行を含む文字列を作成できる`;
```

参考: [Template literal - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/template_strings)

### 数値 (Number型)

* 数値はIEEE 754標準の64ビット浮動小数点数
* 整数値で表現できるのは53ビットまで
* 整数とみなしてビット演算できる

```javascript
var num1 = 100;
var num2 = 0xFF;   // 255 (16 進数)
var num3 = 0o777;  // 511 (8 進数)
var num4 = 0b1010; // 10  (2 進数)
Infinity; // 無限大を表す値
NaN; // 数値ではないことを表す値 (Not a Number)
```

* `NaN` の存在は忘れがちなので注意
* 条件式で `0 <= NaN` も `0 >= NaN` も偽とか、`NaN === NaN` が偽とか

### 真偽値 (Boolean型)

```javascript
true
false
```

### 未定義値 (Undefined型)

* 宣言だけされて代入されてない変数の値は `undefined`

```javascript
undefined // キーワードではなく定義済みの変数
```

### Null値 (Null型)

```javascript
null // `null` はキーワード
```


## オブジェクト (Object型)

* オブジェクトはプロパティの集合
  * プロパティはキーと値の組
* つまりJSにおけるオブジェクトとは辞書 (連想配列、ハッシュ) のようなもの
* 実際には単純な辞書 (key-value pair) ではない
  * プロパティに属性があったり、オブジェクトが内部プロパティを持ってたり、関数の場合は呼び出しができたりする

```javascript
// オブジェクトリテラル
var obj = {
    name: "my name",
    age: 17
};

// 配列リテラル (配列もオブジェクト)
var array = [1,2,3,4,5];

// 関数式 (関数もオブジェクト)
var func = function () { /* ... */ };

// 正規表現リテラル
var regexp = /^abcdef/;
```

### プロパティアクセス

* ドットを使うか、角括弧を使ってオブジェクトのプロパティにアクセス
  * 角括弧を使う場合は、角括弧の中は文字列として評価される

```javascript
obj.name; //=> "my name"
obj["name"]; //=> "my name"

// 代入もできる
obj.name = "new name"; // 改名しました
```

### アクセサプロパティ

オブジェクトのプロパティにsetter, getterを設定できる。

```javascript
var obj = {
    _name: "",
    set name (val) { this._name = val },
    get name () { return this._name }
};

obj.name = "new name";
obj.name; //=> "new name"
```


## ラッパーオブジェクト

* StringやNumberコンストラクタのインスタンス
* ハマりやすいので使わないこと！

プリミティブ値との違い。
```javascript
// ラッパーオブジェクトの型は `object`
typeof "String 値";                          // "string"
typeof new String("`String` オブジェクト");  // "object"

// 等値演算子は参照の等値性をみる  
'yo' === 'yo';                          // true
new String('yo') === new String('yo');  // false
```


## プリミティブ値に対するプロパティアクセス

* String型、Number型、Boolean型の値に対してプロパティ参照が可能
  * 暗黙的にラッパーオブジェクトが生成されている
  * `null`, `undefined` はできない
* プロパティを参照するのは良い
* プロパティへ代入するのはやめよう
  * ラッパーオブジェクトは使い捨てられるので、意味が無い

```javascript
var foo = 'foo';
foo.toString() === 'foo';  // new String(foo).toString() と同じ

foo.bar = 'bar';        // new String(foo).bar = 'bar' と同じ
foo.bar === undefined;  // foo.bar は存在しない
```


## `typeof` 演算子

値の型を調べることができる。
* 注意！!!
  * `null` は `"object"`
  * 関数は `"function"`

```javascript
typeof undefined;      // undefined
typeof 0;              // number
typeof true;           // boolean
typeof {};             // object
typeof [];             // object
typeof null;           // object
typeof "";             // string
typeof new String(""); // object
typeof alert;          // function
```

参照: [typeof 演算子 - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/typeof)


## 数値と文字列の変換

### String => Number

- 単項 `+` 演算子
  ```javascript
  +"3";  // 3
  ```

- parseInt
  - 使うときは必ず基数を渡す [(古い処理系でハマる)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt#Octal_interpretations_with_no_radix)
  ```javascript
  parseInt('010', 10);  // 10
  ```

- Number
  ```javascript
  Number("3");  // 3
  ```

### Number => String

- 文字列結合
  ```javascript
  '' + 3;  // '3'
  ```
- `toString()`
  ```javascript
  var x = 123;
  x.toString();  // '123'
  ```


## 値の比較

JavaScriptの関係演算子は4種類ある。

- 等値演算子 `==` , 不等演算子 `!=`
- 同値演算子 `===`, 非同値演算子 `!==`

- `===`、`!==` を使うこと！
  - `==`、`!=` だと勝手に型変換されてハマる

```javascript
3 ==  '3';  // true
3 === '3';  // false

0 ==  '';  // true
0 === '';  // false

undefined ==  null;  // true
undefined === null;  // false
```

### `NaN` に注意

NaNは自分自身とも等しくない値。

```
NaN == NaN;  //=> false
NaN === NaN; //=> false
```

ちなみに比較演算の結果も悲惨。

```
0 < NaN;  //=> false
0 > NaN;  //=> false
```

文句はJavaScriptじゃなくてIEEEに言うこと。


## `undefined` と `null` の使い分け

* `undefined` は未定義値を示す
  ```javascript
  var foo;
  typeof foo;  // undefined
  ```
* `null` は何も入ってないことを示す
  * 定義されているのでobjectではある
  * `object` が入っていることを示しつつ、空にしてきたい、とか
  ```javascript
  var foo = null
  typeof foo;  // object
  ```

## 真偽評価されたときに偽になる値

いわゆるfalsyな値はつぎの7つ:。

- `false`
- `''` (空文字列)
- `0`
- `-0`
- `NaN`
- `undefined`
- `null`

[厳密には他にもある](https://developer.mozilla.org/ja/docs/Glossary/Falsy)けど気にしなくて良いです  
他はすべて `true` と評価されます。


## 標準オブジェクト

## 配列

配列リテラルでArrayオブジェクトを生成できる。
参考: [Array - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Array)

```javascript
var nums = [1,2,3,4];

// 要素の操作
nums.push(5);    // [1, 2, 3, 4, 5]
nums.pop();      // [1, 2, 3, 4]
nums.unshift(0); // [0, 1, 2, 3, 4]
nums.shift();    // [1, 2, 3, 4]

// ES5以降のメソッド: forEach, map, filter, reduce, etc...
var squared = [1,2,3,4].map(function (value, index, array) {
    return value * value;
});
```
