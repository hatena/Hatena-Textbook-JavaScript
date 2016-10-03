Node.js の基本的な使い方
================================================================

## インストール

- mac だとデフォルトで入ってます
- そうでない方はビルド済みバイナリをダウンロード
  - https://nodejs.org/en/#download  
- rbenv, plenv に似た ndenv というのもあります
  - https://github.com/riywo/ndenv


## Node.js の実行方法

`node` コマンドを使います

- `node (ファイル名)` で JS ファイルを実行する
  ```
  $ echo 'console.log("hello");' > hello.js
  $ node hello.js
  hello  
  ```

- `node -e '(式)'` でワンライナー
  ```
  $ node -e 'console.log(123);'
  123
  ```

- `node` コマンドで REPL が開く
  - ブラウザのコンソールと同じノリで使える

  ```
  $ node
  > 1 + 2
  3
  > console.log('yo');
  yo
  undefined
  >
  > var f = (x) => x * x;
  [Function]
  > f(10);
  100
  > g = () => {
  ... console.log(123);
  ... }
  [Function]
  > g();
  123
  undefined
  ```


## npm

- Node.js 用のパッケージマネージャ
  - Ruby でいう `gem`, Perl でいう `cpanm`
  - 最近ではフロントエンド用のライブラリや CSS ライブラリも管理したり
- 簡易タスクランナーとしても使える
  - 例: はてなブログ
    - `npm test` : テスト実行
    - `npm run build` : JavaScript / CSS ビルド


### npm の使い方

- まずは package.json を作成する
  - プロジェクトの名前やバージョン、依存 npm パッケージなどを記録する
  - npm init すると対話的に作られます
    - `npm init -y` で質問スキップ

`npm init -y` で生成されるファイル

```json
{
  "name": "sample",
  "version": "0.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "foo <foo@example.com>",
  "license": "MIT"
}
```

- `npm install` で npm パッケージをインストール
  - `node_modules/` 下にインストールされる

インストールした npm パッケージは `require('foo')` として使える様になる

```javascript
// `npm install cool-ascii-faces` 済み
var cool = require('cool-ascii-faces');

console.log(cool());  // (๑>ᴗ<๑)
```

`npm install --save` でインストールすると、 package.json に依存パッケージとして記録される

```js
{
  "name": "sample",
  // 中略
  "dependencies": {
    "cool-ascii-faces": "^1.3.4"
  }
}
```
