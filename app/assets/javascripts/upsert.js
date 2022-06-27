App.Lib.Upsert = function (target, data) {
  data = data || {};
  target.data = data;
  target.mode = target.data.id ? 'edit' : 'new';

  target.isNew = function () {
    return target.mode === 'new';
  }
}