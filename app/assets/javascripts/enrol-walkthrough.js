function enrolWalkthrough() {
	$(document).ready(function() {
		var intro = introJs();
		intro.setOptions({
			steps: [
				{ 
					intro: "This is the course page. Each course consists of number of different tasks that you will need to complete."
				},
				{
					element: document.querySelector('#learning-item'),
					intro: "When you are ready to start, click on the first task to open it."
				},
				{
					element: document.querySelector('#learning_from_item'),
					position: 'left',
					intro: "Click the back button to return to your dashboard. Don't worry, all of your progress is saved, and you can return anytime."
				}
			]
		});
		intro.start();
	});
};
