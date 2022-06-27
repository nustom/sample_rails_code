App.Lib.Dropzone = function (selector, options) {
  if (options === null || options === undefined) { options = {} };

  // do not change this 15 minute timeout. this is set
  // because large files can take > 30 seconds, which is
  // the default value. if the timeout is exceeded dropzone
  // fails silently without error.
  options.timeout         = 900000;
  options.parallelUploads = 5;

  var dropzone = new Dropzone(selector, options);

  if (options.events) {
    for (var key in options.events) {
      if (options.events.hasOwnProperty(key)) {
        dropzone.on(key, options.events[key]);
      }
    }
  }

  document.querySelector('.dz-upload-file').addEventListener('click', function (e) {
    e.preventDefault();
  });

  App.Page = App.Page || {};
  App.Page.DropzoneInstances = App.Page.DropzoneInstances || [];

  App.Page.DropzoneInstances.push(dropzone);
}

App.Lib.Dropzone.S3FolderSendingPreset = function (presignPostParams, file, formData) {
  var key = presignPostParams.key_start + App.Lib.Dropzone.GenerateKeyFileName(file.name);
  file.s3Key = key;
  formData.append('key', file.s3Key);
  formData.append('X-Requested-With', 'xhr');
  formData.append('Content-Type', file.type);
  formData.append('success_action_status', 201);
  formData.append('bucket', presignPostParams.bucket);
  formData.append('acl', presignPostParams.acl);
  formData.append('policy', presignPostParams.policy);
  formData.append('signature', presignPostParams.signature);
  formData.append('AWSAccessKeyId', presignPostParams.access_key)
}

App.Lib.Dropzone.GenerateKeyFileName = function (fileName) {
  function sanitizeFilename(fileName) {
    // slice(0) returns a new array so pop() doesnt modify the original
    var extension = fileName.split('.').slice(0).pop();

    // \W matches any non-word character
    return fileName.replace('.' + extension, '').replace(/\W+/g, '-') + '.' + extension;
  }

  return (new Date()).getTime() + '-' + sanitizeFilename(fileName);
}