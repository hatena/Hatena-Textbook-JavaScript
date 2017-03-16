課題4-1のヒント (Scala編)
================================================================

## JavaScriptの配置と読み込み

- `src/main/webapp/javascripts` ディレクトリにファイルを置くこと
  - `src/main/webapp/javascripts/main.js` を作成した場合、以下のようにロードする

```scala
<script src="/javascripts/main.js"></script>
```

## JSONへのエンコード

- JSON形式のデータを構築するためのライブラリがいくつかあるが、 Intern-Bookmarkでは [json4s](http://json4s.org/) を利用する
- 以下のようなコードで `case class` のインスタンスをJSON形式にエンコードできる

```scala
scala> case class User(id: Long, name: String)
defined class User

scala> implicit val formats = org.json4s.DefaultFormats
formats: org.json4s.DefaultFormats.type = org.json4s.DefaultFormats$@1d4a4f9e

scala> org.json4s.jackson.Serialization.write(User(id = 42L, name = "example-user"))
res0: String = {"id":42,"name":"example-user"}
```

- `implicit` 宣言されている `formats` オブジェクトに基づいてシリアライズが行われる
- 多くの場合、 json4sに付属の `DefaultsFormats` オブジェクトをそのまま利用するだけで十分
  - `DefaultsFormats` が対応していない型のオブジェクトをシリアライズする場合、カスタマイズすることもできる

- Intern-Bookmarkの `internbookmark.service.Json` オブジェクトの定義は以下のとおり
  - `LocalDateTime` 型や `Long` 型の値のシリアライズ方式を独自に設定している
  - Intern-Diaryの実装でも、このオブジェクトと同じ実装が利用できる

```scala
package internbookmark.service

import org.joda.time.LocalDateTime
import org.json4s._

object Json {
  val Formats = DefaultFormats + LocalDateTimeSerializer + LongIdSerializer
}

class object LongIdSerializer extends CustomSerializer[Long](format => (
  { case JString(s) => s.toLong         },
  { case x: Long => JString(x.toString) }
))

case object LocalDateTimeSerializer extends CustomSerializer[LocalDateTime](format => (
  {
    case JInt(s) => new LocalDateTime(s.toLong)
    case JNull => null
  },
  {
    case d: LocalDateTime => JInt(BigInt(d.toDateTime().getMillis))
  }
))
```

## JSONからのデコード

- エンコードと同じく [json4s](http://json4s.org/) を利用する
- `parse` メソッドでJSONを解析して読み込んだあと、 `extractOpt` メソッドなどを用いてデータを読み込む

```scala
scala> val json = org.json4s.jackson.JsonMethods.parse("""{"id":42,"name":"example-user"}""")
json: org.json4s.JValue = JObject(List((id,JInt(42)), (name,JString(example-user))))

scala> (json \ "id").extractOpt[Int]
res1: Option[Int] = Some(42)

scala> (json \ "name").extractOpt[String]
res2: Option[String] = Some(example-user)

scala> (json \ "no-such-key").extractOpt[String] // キーが存在しない場合
res3: Option[String] = None

```

## コントローラの実装

- Scalatraではjson4sが組込まれており、リクエストからJSONを読み込んで、レスポンスとしてJSONを返すようなコントローラを簡単に実装できる
- 自分で `parse` したり `write` したりする必要はない

- 以下のコードはIntern-Bookmarkの `internbookmark.web.BookmarkAPIWeb` traitから抜粋したもの
  - `internbookmark.web.BookmarkWeb` にmixinして利用されている

```scala

// ...

// JacksonJsonSupport を継承する必要がある
trait BookmarkAPIWeb extends JacksonJsonSupport { self: BookmarkWeb with AppContextSupport =>
  protected implicit val jsonFormats: Formats =
    internbookmark.service.Json.Formats // json4sが使うFormatsをoverrideして設定しておく

  // ...

  post("/api/bookmark") {
    contentType = formats("json") // Content-Typeヘッダを application/json に設定
    val json = parsedBody // リクエストボディをパースしてjson4s.JValueオブジェクトを取得

    val app = createApp()

    // extractOpt を利用してリクエストからデータを取得
    val req = for {
      url <- (json \ "url").extractOpt[String].toRight(BadRequest()).right
      comment <- Right((json \ "comment").extractOrElse("")).right
      bookmark <- app.add(url, comment).left.map(_ => InternalServerError()).right
    } yield bookmark

    req match {
      case Right(bookmark)   => bookmark // jsonFormatsが変換できる値であれば、そのまま返すことでJSONに変換される
      case Left(errorResult) => errorResult.copy( // 明示的にJValue型の値を返してもよい
        body = JObject("error" -> JString(errorResult.status.message)))
    }
  }
}
```

参考: [Scalatra のドキュメント](http://www.scalatra.org/2.4/guides/formats/json.html)
