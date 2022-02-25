# Dart URL Builder Documentation V 1.0

## Path Bindings
#### Example  with Bracket : 
    var url = "api.com/post/{slug}";
    final urlBuilder = UrlBuilder.parse(url, pathBindings: 
	    {
		    "slug": "hot-news-article"
	    }
    );

#### Example  with Colon  : 
    var url = "api.com/post/:slug";
    final urlBuilder = UrlBuilder.parse(url, pathBindings: 
	    {
		    "slug": "hot-news-article"
	    }
    );
    
    Result will be : "api.com/post/hot-news-article"

## Query Bindings
### Basic Example : 
	By default if register queryBindings will append to url.
    var url = "api.com/post";
    final urlBuilder = UrlBuilder.parse(url, queryBindings: 
	    {
		    "slug": "hot-news-article"
	    },
	    {
		    "id": 1
	    }
    );
    
    Result : "api.com/post?slug=hot-news-article&user=1"

### Example with  Existing Query Params: 
Existing query parameter will be replace if register same key query parameter on queryBindings, otherwise will append query parameter to url.
#### Overriding

    var url = "api.com/post?slug&id=20";
    final urlBuilder = UrlBuilder.parse(url, queryBindings: 
	    {
		    "slug": "hot-news-article"
	    },
	    {
		    "id": 1
	    }
    );
    
    Result : "api.com/post?slug=hot-news-article&user=1"

#### Overriding & Append
	
    var url = "api.com/post?slug&id=20";
    final urlBuilder = UrlBuilder.parse(url, queryBindings: 
	    {
		    "slug": "hot-news-article"
	    },
	    {
		    "id": 1
	    },
	    {
		    "region": "id-ID"
	    }
    );
    
    Result : "api.com/post?slug=hot-news-article&user=1&region=id-ID"

## Structure Recommendation

    import  'url_builder.dart';

	abstract  class  ApiServiceItemPath {
		static  String  get  _root => "items";
		static  String  get  _lists => _root;
		static  String  get  _detail => "items/{id}";

	}

	class  ApiServiceItem {
		ApiServiceItem();
		
		static  String  list() {
			return  ApiServiceItemPath._lists;
		}

		static  String  detail({required  int  id}) {
			return  UrlBuilder.parse(ApiServiceItemPath._detail,
				pathBindings: {'id': id});
		}
	}
