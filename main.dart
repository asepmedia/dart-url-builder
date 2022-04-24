import 'url_builder.dart';

/**
Hello
 */
void main() {
  pathBinding();
  print("");
  queryBinding();
}

void queryBinding() {
  var url, result;
  // Basic
  url = "api.com/post";
  result = UrlBuilder.parse(url,
      queryBindings: {"slug": "hot-news-article", "id": 1});
  print("QUERY BINDINGS : Basic = $result");

  // With existing Query Params
  // id=20 will override by id = 1 in queryBindings
  url = "api.com/post?id=20&slug";
  result = UrlBuilder.parse(url,
      queryBindings: {"slug": "hot-news-article", "id": 1});
  print("QUERY BINDINGS : Basic = $result");

  // id=20 will override by id = 1 in queryBindings
  url = "api.com/post?id=20";
  result = UrlBuilder.parse(url,
      queryBindings: {"slug": "hot-news-article", "id": 1, "region": "id-ID"});
  print("QUERY BINDINGS : Basic = $result");
}

void pathBinding() {
  var url, result;
  // Sample with Bracket
  url = "api.com/post/{slug}";
  result = UrlBuilder.parse(url, pathBindings: {"slug": "hot-news-article"});
  print("PATH BINDINGS : Bracket = $result");

  // Sample with colon
  url = "api.com/post/:slug/deep/:user";
  result = UrlBuilder.parse(url,
      pathBindings: {"slug": "hot-news-article", "user": "asep"});
  print("PATH BINDINGS : Colon = $result");

  // Sample mixed
  url = "api.com/post/{slug}/deep/:user";
  result = UrlBuilder.parse(url,
      pathBindings: {"slug": "hot-news-article", "user": "asep"});
  print("PATH BINDINGS : Mixed = $result");
}
