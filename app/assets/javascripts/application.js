// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-fileupload/basic
//= require bootstrap-sprockets

//= require_tree .
//= require intro.min.js

//= require froala_editor.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/link.min.js
//= require plugins/table.min.js
//= require plugins/image.min.js
//= require plugins/draggable.min.js
//= require plugins/fullscreen.min.js
//= require plugins/colors.min.js
//= require plugins/font_size.min.js
//= require plugins/video.min.js
//= require plugins/align.min.js
//= require camera-tag.js
//= require typeahead.min.js
//= require moment.min.js
//= require flatpickr.min.js
//= require promise-shim.min.js
//= require dropzone.min.js
//= require fullcalendar.min.js
//= require selectize.min
//= require jstz.min.js
//= require Chart.min.js
//= require Chart.PieceLabel.min.js

// this function does two things.
// it updates the URL hash with the current tab that is selected.
// it also ensures that when the page reloads, it selects the tab in
// url hash.
//




$(function(){
	var hash = window.location.hash;
	hash && $('ul.nav a[href="' + hash + '"]').tab('show');

	$('.nav-tabs a').click(function (e) {
		$(this).tab('show');
		var scrollmem = $('body').scrollTop() || $('html').scrollTop();
		window.location.hash = this.hash;
		$('html,body').scrollTop(scrollmem);
	});
});


$(function() {
	$("#submit-form").click(function() {
		$("#file_upload").remove();
		return true;
	});
});

$(function() {
	$('.picture-uploader').find("input:file").each(function(i, elem) {
		var fileInput    = $(elem);
		var form         = $(fileInput.parents('form:first'));
		var submitButton = form.find('input[type="submit"]');
		var progressBar  = $("<div class='bar' style='color:white;text-align:center'></div>");
		var barContainer = $("<div class='progress'></div>").append(progressBar);
		fileInput.after(barContainer);
		fileInput.fileupload({
			fileInput:       fileInput,
			url:             form.data('url'),
			type:            'POST',
			autoUpload:       true,
			formData:         form.data('form-data'),
			paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
			dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
			replaceFileInput: false,
			progressall: function (e, data) {
				var progress = parseInt(data.loaded / data.total * 100, 10);
				progressBar.css('width', progress + '%')
			},
			start: function (e) {
				submitButton.prop('disabled', true);

				progressBar.
					css('background', 'green').
					css('display', 'block').
					css('width', '0%').
					text("Loading...");
			},
			done: function(e, data) {
				submitButton.prop('disabled', false);
				progressBar.text("Uploaded! Please click save.");

				// extract key and generate URL from response
				var key   = $(data.jqXHR.responseXML).find("Key").text();
				var url   = form.data('host') + '/' + form.data('key');

				// create hidden field
				var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
				form.append(input);
			},
			fail: function(e, data) {
				submitButton.prop('disabled', false);

				progressBar.
					css("background", "red").
					text("Failed");
			}
		});
	});
});

$(function() {
	$('.directUpload').find("input:file").each(function(i, elem) {
		var fileInput    = $(elem);
		var form         = $(fileInput.parents('form:first'));
		var submitButton = form.find('input[type="submit"]');
		var progressBar  = $("<div class='bar'></div>");
		var barContainer = $("<div class='progress'></div>").append(progressBar);
		fileInput.after(barContainer);
		fileInput.fileupload({
			fileInput:       fileInput,
			url:             form.data('url'),
			type:            'POST',
			autoUpload:       true,
			formData:         form.data('form-data'),
			paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
			dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
			replaceFileInput: false,
			progressall: function (e, data) {
				var progress = parseInt(data.loaded / data.total * 100, 10);
				progressBar.css('width', progress + '%')
			},
			start: function (e) {
				submitButton.prop('disabled', true);

				progressBar.
					css('background', 'green').
					css('display', 'block').
					css('width', '0%').
					text("Loading...");
			},
			done: function(e, data) {
				submitButton.prop('disabled', false);
				progressBar.text("");

				// extract key and generate URL from response
				var key   = $(data.jqXHR.responseXML).find("Key").text();
				var url   = form.data('prefix')

				// create hidden field
				var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
				form.append(input);
			},
			fail: function(e, data) {
				submitButton.prop('disabled', false);

				progressBar.
					css("background", "red").
					text("Failed");
			}
		});
	});
});
