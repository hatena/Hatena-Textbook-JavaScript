課題4-1のヒント (Perl編)
================================================================

## JavaScriptの配置と読み込み

- `static/js` ディレクトリにファイルを置くこと
  - `static/js/main.js` を作成した場合、以下のようにロードする

```html
<script src="/js/main.js"></script>
```

## JSONへのエンコード

JSON形式のデータを構築するためのライブラリはいくつかあるが、ここでは [`JSON::XS`](https://metacpan.org/module/JSON::XS) を利用する。

```perl
use JSON::XS;
my $user = { user_id => 42, name => 'example-user' };
my $json_string = JSON::XS::encode_json($user);
```

- `JSON::XS` は `bless` されたオブジェクトをJS
  - `JSON::Types` などを用い、プレーンなHashRefを作って渡す
- 例: あるクラスのインスタンスをJSON形式でシリアライズしたい場合
  - モデルクラスに `json_hash` のようなメソッドを生やす

```perl
package Inter::Diary::Model::User;
use strict;
use warnings;

use JSON::Types ();
use Class::Accessor::Lite (
    ro => [qw(user_id name)],
    new => 1,
);

sub json_hash {
    my ($self) = @_;
    return +{
        user_id => JSON::Types::number $self->user_id,
        name    => JSON::Types::string $self->name,
    };
}
```

```perl
require JSON::XS;
my $user = Intern::Diary::Model::User->new(
    user_id => 42,
    name => 'example-user',
);
my $json_string = JSON::XS::encode_json($user->json_hash);
```

## JSONからのデコード

エンコードの場合と同じく [`JSON::XS`](https://metacpan.org/module/JSON::XS) でデコードできる。

```perl
require JSON::XS;
my $json_string = '{"user_id": 42, "name":"example-user"}';
my $user_hash = JSON::XS::decode_json($json_string);    # プレーンなハッシュリファレンスが返る
my $user = Intern::Diary::Model::User->new($user_hash); # ハッシュリファレンスからモデルのインスタンスを作る
```

## コントローラの実装

- コントローラに渡される `$c` を使うと、簡単にJSON形式のレスポンスを返せる
  - Hatena::Newbieのコンテキストオブジェクト
- `$c->html()` の代わりに `$c->json()` を呼ぶと、 HTMLではなくJSON形式のレスポンスが返る
  - 内部で `JSON::XS` を使っている
  - やはり `bless` されている値は渡せない

```perl
package Intern::Diary::Engine::API;
use strict;
use warnings;

sub user {
    my ($class, $c) = @_;
    my $user = { user_id => 42, name => 'example-user' };
    $c->json($user);
}
```
