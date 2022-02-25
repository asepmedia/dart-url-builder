class UrlBuilder {
  static String _url = "";
  static dynamic _pathBindings;
  static dynamic _queryBindings;
  static RegExp _FindAndSymbolAtEnd = RegExp(r'\&+$');
  static RegExp _findOnlyQueryParameterRegex = RegExp(r'(?:\?.*)');
  static RegExp _findQuestionSymbolRegex = RegExp(r'(?:\?)');
  static RegExp _findValueQueryParameterRegex = RegExp(r'(?:\=.*)');
  static RegExp _findPathParameterRegex =
      RegExp(r'(?:\{[a-zA-Z]+})|(?:\:[a-zA-Z]+)');
  static RegExp _findPathParameterValueRegex = RegExp(r'(?:\:)|(?:\{|})');

  static String parse(String url,
      {dynamic pathBindings, dynamic queryBindings}) {
    _url = url;
    _pathBindings = pathBindings;
    _queryBindings = queryBindings;
    return bindings();
  }

  static String bindings() {
    if (_pathBindings != null) {
      _url = pathBindings();
    }
    if (_queryBindings != null) {
      _url = queryBindings();
    }
    return _url;
  }

  static String pathBindings() {
    if (_pathBindings != null) {
      Iterable<Match> matches = _findPathParameterRegex.allMatches(_url);
      List<Match> listOfMatches = matches.toList();

      listOfMatches.forEach((e) {
        var rawKey = e.group(0).toString();
        var key = rawKey.replaceAll(_findPathParameterValueRegex, "");
        if (_pathBindings.containsKey(key)) {
          _url = _url.replaceAll(rawKey, _pathBindings[key]);
        }
      });
    }
    return _url;
  }

  static String queryBindings() {
    final hasQuestionSymbol = _findQuestionSymbolRegex.hasMatch(_url);

    // append symbol "?" if doesnt have
    if (!hasQuestionSymbol) {
      _url += "?";
    }

    var queryParameters = "";
    var onlyQueryparameter =
        _findOnlyQueryParameterRegex.stringMatch(_url).toString();

    var onlyQueryparameterSplits =
        onlyQueryparameter.split("&").where((e) => e != "?");

    // append and override query value on path if register queryBindings
    onlyQueryparameterSplits.forEach(
      (e) {
        var currentKey = e.replaceAll(_findQuestionSymbolRegex, "");
        var currentValue = _findValueQueryParameterRegex.stringMatch(e) ?? "";

        if (currentValue != null) {
          currentKey = currentKey.replaceAll(currentValue, "");
          currentValue = currentValue.replaceAll("=", "");
        }
        if (_queryBindings != null && _queryBindings.containsKey(currentKey)) {
          currentValue = _queryBindings[currentKey].toString();
        }
        queryParameters += currentKey + "=" + currentValue.toString() + "&";
      },
    );

    // override query parameter based on queryBindings value
    if (_queryBindings != null) {
      _queryBindings.map((k, v) {
        if (!queryParameters.contains(k)) {
          queryParameters += k + "=" + v.toString() + "&";
        }
        return MapEntry(v, k);
      });
    }

    queryParameters = queryParameters.replaceAll(_FindAndSymbolAtEnd, "");

    return _url.replaceAll(_findOnlyQueryParameterRegex, "?") + queryParameters;
  }
}
