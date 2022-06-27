App.Lib.Typeahead = function(selector, endpoint, displayKey, options) {
  var endpoint = endpoint + '?q=%QUERY';
  if (options.additionalParams) {
    for (var key in options.additionalParams) {
      if (options.additionalParams.hasOwnProperty(key)) {
        endpoint += '&' + key + '=' + options.additionalParams[key];
      }
    }
  }

  var remoteSource = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace(displayKey),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: endpoint,
      wildcard: '%QUERY'
    }
  });

  options = options || {};

  $(selector).typeahead(null, {
    display: displayKey,
    source: remoteSource,
    minLength: 2
  });

  if (options.onSelect) {
    $(selector).on('typeahead:selected', function(e, selected) {
      options.onSelect.apply(null, [e, selected]);
    });
  }
}