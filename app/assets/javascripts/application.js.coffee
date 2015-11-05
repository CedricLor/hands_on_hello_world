# app/assets/javascripts/application.js.coffee
$ ->
	React.renderComponent(
		React.DOM.div({}, "Hello world!"),
		document.body
	)
