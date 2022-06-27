App.Lib.CameraTagInit = (function () {
  function initialise(type) {
    $(document).ready(function() {
      var cameraTagInstance;

      CameraTag.observe('camera-recorder', 'published', function() {
        var uuid;

        switch (type) {
          case 'photo':
            uuid = cameraTagInstance.getPhoto().uuid;
          break;
          case 'video':
            uuid = cameraTagInstance.getVideo().uuid;
          break;
        }

        var mediaRecordedEl = createMediaRecordedHiddenField();
        var publishedMediaUUIDEl = createPublishedMediaUUIDHiddenField(uuid);
        questionSubmitEl = document.getElementById('question-submit-content');

        questionSubmitEl.appendChild(mediaRecordedEl);
        questionSubmitEl.appendChild(publishedMediaUUIDEl);

        document.getElementById('btn_question_submit').disabled = false;
      });

      CameraTag.observe('camera-recorder', 'initialized', function() {
        switch (type) {
          case 'photo':
            cameraTagInstance = CameraTag.photobooths['camera-recorder'];
          break;
          case 'video':
            cameraTagInstance = CameraTag.cameras['camera-recorder'];
          break;
        }

        if (type === 'photo') {
          hidePhotoboothOverlap();
        }
      });
    });
  }

  function hidePhotoboothOverlap() {
    var photoBoothContainer = document.querySelector('.cameratag_photobooth_container');
    if (!photoBoothContainer) { return; }

    var overlapDiv = photoBoothContainer.children[1];
    if (overlapDiv) {
      photoBoothContainer.removeChild(overlapDiv);
    }
  }

  function createPublishedMediaUUIDHiddenField(uuid) {
    publishedMediaUUIDEl = document.createElement('input');
    publishedMediaUUIDEl.value = uuid;
    publishedMediaUUIDEl.setAttribute('name', 'published-media-uuid');
    publishedMediaUUIDEl.setAttribute('type', 'hidden');
    return publishedMediaUUIDEl;    
  }

  function createMediaRecordedHiddenField() {
    mediaRecordedEl = document.createElement('input');
    mediaRecordedEl.value = true;
    mediaRecordedEl.setAttribute('name', 'media-recorded');
    mediaRecordedEl.setAttribute('type', 'hidden');
    return mediaRecordedEl;
  }

  return {
    initialise: initialise
  }
}());