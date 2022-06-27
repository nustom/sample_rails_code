App.Lib.Timeparser = function (selector) {
  var input = document.querySelector(selector);
  if (input === null) { return; }

  function padTimePart(part) {
    if (part.toString().length === 2) { return part; }
    return part + '0';
  }

  function invalidTime(input) {
    input.value = '';
    return;
  }

  input.addEventListener('blur', function (e) {

    var value = input.value;

    var time = value.match(/(\d+)(?::(\d\d))?\s*(p?)/);

    // if there are no matches the time is not valid  
    if (!time) { return invalidTime(input); }

    // get rid of the first match, it is essentially a combination
    // of all other matches e.g. 10:00p, pretty much the input
    time.shift();

    // extract the parts
    var hours = time[0];
    var mins  = time[1] || '00';
    var ampm  = time[2] || 'am';

    // if the hours are more than 2 digits and mins are 0
    // then we assume they are trying to enter a time without
    // any :
    if (hours.length > 2 && mins === '00') {

      // don't be nuts
      if (hours.length > 4) { return invalidTime(input); }

      if (hours.length === 3) {
        mins  = hours.substr(1);
        hours = hours.substr(0, 1);
      } else if (hours.length === 4) {
        mins  = hours.substr(2);
        hours = hours.substr(0, 2);
      }
    }

    // if hours > 12 disregard am/pm, because we are working
    // with 24 hour time
    var parsedHours = parseInt(hours, 10);
    var parsedMins  = parseInt(mins, 10);

    // don't be nuts
    if (parsedHours > 24 || parsedMins > 59) { return invalidTime(input); }

    if (parsedHours > 12) {
      parsedHours = parsedHours - 12;
      ampm        = 'pm';
    } else if (parsedHours === 12) {
      ampm        = 'pm';
    }

    if (ampm === 'p') { ampm = 'pm'; }

    // construct the formatted time
    var formatted = parsedHours + ':' + padTimePart(parsedMins) + ampm;

    input.value = formatted;
  });
}