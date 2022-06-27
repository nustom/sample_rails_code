App.Lib.TimezoneService = App.Lib.TimezoneService || (function () {
  this.offset = '';
  
  function setOffset(offset) {
    this.offset = offset;
  }

  function now(date, format) {
    if (format && date) { return withOffset(moment(date, format, true)); }
    if (date)           { return withOffset(moment(date)); }
    return withOffset(moment());
  }

  function withOffset(mdate) {
    overrideToDate(mdate);
    return mdate.utcOffset(this.offset);
  }

  function overrideToDate(mdate) {
    mdate.toDate = function toDate() { return new Date(this.format('YYYY-MM-DDTHH:mm')) }
  }

  function guessTimezone() {
    if (!jstz) { return 'Australia/Brisbane'; }
    var timezone = jstz.determine();
    if (!timezone) { return 'Australia/Brisbane'; }
    return timezone.name();
  }

  function offset() {
    return this.offset;
  }

  return {
    setOffset: setOffset.bind(this),
    now: now.bind(this),
    guessTimezone: guessTimezone,
    offset: offset.bind(this)
  }
}());