# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
	container = document.getElementById("CreateNewMeetup")
	technologies = JSON.parse( container.dataset.technologies )
	ReactDOM.render(
		React.createElement(
			CreateNewMeetupForm
			{technologies: technologies}
		),
		container
	)
