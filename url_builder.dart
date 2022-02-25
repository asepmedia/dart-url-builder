class UrlBuilder {
  static String _url = "";
  static dynamic _pathBindings;
  static dynamic _queryBindings;
  static RegExp _removeAndSysmbolAtEnd = RegExp(r'\&+$');
  static RegExp _onlyQueryParameterRegex = RegExp(r'(?:\?.*)');
  static RegExp _questionMarkRegex = RegExp(r'(?:\?)');
  static RegExp _valueQueryParameterRegex = RegExp(r'(?:\=.*)');

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
      _pathBindings.map((k, v) {
        final replaceValue = v.toString();
        _url = _url.replaceAll("{${k}}", replaceValue);
        _url = _url.replaceAll(":${k}", replaceValue);
        return MapEntry(v, k);
      });
    }
    return _url;
  }

  static String queryBindings() {
    final hasQuestionMark = _questionMarkRegex.hasMatch(_url);
    if (!hasQuestionMark) {
      _url += "?";
    }

    var queryParameters = "";
    var onlyQueryparameter =
        _onlyQueryParameterRegex.stringMatch(_url).toString();

    var onlyQueryparameterSplits =
        onlyQueryparameter.split("&").where((e) => e != "?");

    // appends and override query value on path if register queryBindings
    onlyQueryparameterSplits.forEach(
      (e) {
        var currentKey = e.replaceAll(_questionMarkRegex, "");
        var currentValue = _valueQueryParameterRegex.stringMatch(e) ?? "";

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

    if (_queryBindings != null) {
      _queryBindings.map((k, v) {
        if (!queryParameters.contains(k)) {
          queryParameters += k + "=" + v.toString() + "&";
        }
        return MapEntry(v, k);
      });
    }

    queryParameters = queryParameters.replaceAll(_removeAndSysmbolAtEnd, "");

    return _url.replaceAll(_onlyQueryParameterRegex, "?") + queryParameters;
  }
}
