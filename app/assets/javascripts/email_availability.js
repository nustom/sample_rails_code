function getAvailaibility(email) {
	$.ajax({
		url: '/echeck?e=' + email,
		type: 'GET',
		dataType: 'json',
		contentType: 'application/json',
		success: function(res) {
			processEmailAvailability(res, email);
		}
	})
};

function processEmailAvailability(response, email) {
	if (response.available == false) {
		var message = "You already have an account with us. <a id=\"login-redirect\" href=\"/login?e=" + escape(email) + "\">Log in here.</a>"
		$("#email-alert").html(message);
		$("#email-alert").show();
		$("#first_name").prop('disabled', true)
		$("#last_name").prop('disabled', true)
		$("#submit").prop('disabled', true)
	} else {
		$("#email-alert").hide();
		$("#first_name").prop('disabled', false)
		$("#last_name").prop('disabled', false)
		$("#submit").prop('disabled', false)
	}
};

$(document).ready(function() {
	$('#email').blur(function() {
		var email = $('#email').val();
		if (email != "") {
			getAvailaibility(email);
		}
	});
})
