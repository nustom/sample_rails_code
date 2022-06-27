App.Lib.Flatpickr = function(selector, options) {
  var validDateFormats = [
    'YYYY-MM-DD',
    'DD/MM/YYYY',
    'dddd DD MMMM YYYY',
    'D/M/YYYY',
    'D/M/YY'
  ];

  if (document.querySelector(selector) === null) { return; }
  
  options = options || {};

  if (!options.dateFormat) {
    options.dateFormat = 'l d F Y';
  }

  options.animate    = false;

  if (options.minDate) {
    options.minDate = App.Lib.TimezoneService.now(options.minDate).startOf('day').toDate();
  }

  if (options.maxDate) {
    options.maxDate = App.Lib.TimezoneService.now(options.maxDate).startOf('day').toDate();
  }

  options.parseDate = function (dateString) {
    var parsed = parseDate(dateString);

    // we don't have access to flatpickr here so we must clear the input
    if (!parsed.isValid()) { return ''; }
    return parsed.toDate();
  }

  var instance = flatpickr(selector, options);

  instance.input.addEventListener('blur', function (e) {

    // don't do anything if the picker is clicked
    if (e.relatedTarget !== null && e.relatedTarget !== undefined && e.relatedTarget.className.indexOf('flatpickr') > -1) {
      return;
    }

    // check if the entered value is a valid date
    var value  = e.target.value;
    if (value === '') {
      instance.clear();
      return;
    }

    var parsed = parseDate(value);
    if (!parsed.isValid()) {
        instance.clear();
        return;
    }

    // check if the current date differs from the new date
    var currentDate = instance.selectedDates[0];
    if (App.Lib.TimezoneService.now(currentDate).isSame(parsed)) { return; }

    instance.setDate(parsed.toDate(), true);
  });

  function parseDate(dateString) {
    var parsed;
    for (var i = 0; i < validDateFormats.length; i++) {
      parsed = App.Lib.TimezoneService.now(dateString, validDateFormats[i]);
      if (parsed.isValid()) { break; }
    }
    return parsed;
  }

  App.Page = App.Page || {};
  App.Page.FlatpickrInstances = App.Page.FlatpickrInstances || [];
  App.Page.FlatpickrInstances.push(instance);
  App.Page.FlatpickrInstancesFind = function flatpickrInstancesFind(selector) {
    for (var i = 0; i < App.Page.FlatpickrInstances.length; i++) {
      selector = selector.replace(/\#|\./g, '');
      var instance = App.Page.FlatpickrInstances[i];
      if (instance.element.classList.contains(selector) || instance.element.id === selector) {
        return instance;
      }
    }
  }
}