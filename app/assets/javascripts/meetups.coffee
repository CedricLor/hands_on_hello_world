# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# $ ->
# 	ReactDOM.render(
# 		React.createElement(CreateNewMeetupForm),
# 		document.getElementById("CreateNewMeetup")
# 	)

$ ->
	element = document.getElementById("CreateNewMeetup")
	app = new CreateNewMeetup(element)
	app.render()