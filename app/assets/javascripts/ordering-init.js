App.Lib.Ordering = (function () {
  function initialise(selector, url, orderType) {
    this.selector  = selector;
    this.url       = url;
    this.orderType = orderType;

    $(document).ready(onReady.bind(this));
  }

  function calculatePosition(idx, orderType) {
    return orderType === 'zeroBased' ? idx : idx + 1;
  }

  function onReady() {

    // must be captured in the function so it is usable below
    var url       = this.url;
    var orderType = this.orderType;

    $(this.selector).sortable({
      stop: function() {
        var orderPositions = [];

        $('input.currentposition').each(function(idx, value) {
          orderPositions.push({
            id: value.id,
            position: calculatePosition(idx, orderType)
          })
        });

        $.ajax({
          url: url,
          type: 'POST',
          dataType: 'json',
          data: JSON.stringify({ ordering: orderPositions }),
          contentType: 'application/json',
          success: function(res) {},
          error: function(err) {
            console.error('An error occurred while trying to save the sort order');
          }
        })
      }
    });
  }

  return {
    initialise: initialise
  }
}());
