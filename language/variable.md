変数
----------------------------------------------------------------

## 変数の宣言方法

宣言方法は var, let, const の3つ

### var

- 関数スコープの変数を宣言
- for や if などのブロック `{}` でスコープを作らない

以下のコードでは `i`, `x` がブロック内で宣言されているが、ブロックの外から参照できる
```javascript
(() => {
    for (var i = 0; i < 3; i++) { ... }
    console.log(i);  // 3

    if (true) { var x = 100; }
    console.log(x);  // 100
})();
```

内部的には次のように解釈される
```javascript
(() => {
    var i, x;

    for (i = 0; i < 3; i++) { ... }
    console.log(i);

    if (true) { x = 100; }
    console.log(x);
})();
```

### let

- ブロックスコープの変数を宣言

```javascript
(() => {
    for (let i = 0; i < 3; i++) { 1 }
    console.log(i);  // ReferenceError: i is not defined
})();
```

```javascript
if (true) { let x = 100; }
console.log(x);  // ReferenceError: x is not defined
```

### const

- ブロックスコープの定数を宣言
- 一度定義したら再代入できない

```javascript
const foo = 'foo';
foo = 'bar';  // TypeError: Assignment to constant variable
```


## 変数の巻き上げ (hoisting)

代表的ハマりポイント！

変数を var で宣言するとき、宣言より上で参照してもエラーにならない
```javascript
var foo = 1;
(function () {
    console.log(foo);  // undefined
    var foo = 2;
    console.log(foo);  // 2
})();
```

内部的には次のように解釈されている
```javascript
var foo = 1;
(function () {
    var foo;     // 宣言を関数の先頭に巻き上げる
    alert(foo);  // 代入はまだなので undefined
    foo = 2;
    alert(foo);
})();
```

let や const で宣言した変数は、宣言より前に触ろうとするとエラーが出る
```javascript
let foo = 1;
(function () {
    console.log(foo);  // ReferenceError: foo is not defined
    let foo = 2;
    console.log(foo);  // 実行されない
})();
```


## var と let, const の使い分け

- 環境が許せば let, const を使おう
  - 最新のブラウザのみ対応すればよいとか
  - Babel, TypeScript が使えるとか  
- 上記以外の環境では var で我慢
  - ハマりやすいので注意  


## クロージャ

* 変数は基本的に関数スコープ
  * 関数オブジェクト生成時に環境がつくられる
  * 値を関数の中に閉じ込めることができる

クロージャでつくったカウンター

```javascript
function createCounter () {
    var i = 0;
    return function () {
        return ++i;
    };
};

var counter1 = createCounter();
var counter2 = createCounter();
alert(counter1()); //=> 1
alert(counter1()); //=> 2
alert(counter2()); //=> 1
alert(counter2()); //=> 2
```

private でつくる

```javascript
function defineAdd (i) {
    return function(v) {
        return i + v;
    };
};

var add1 = defineAdd(1);
var add2 = defineAdd(2);
alert(add1(1)); //=> 2
alert(add2(1)); //=> 3
alert(defineAdd(1)(2)); //=> 3
```
