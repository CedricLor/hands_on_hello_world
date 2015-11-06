# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

OneTimeClickLink = React.createClass
	getInitialState: ->
		{ clicked: false }

	linkClicked: ->
		@setState(clicked: true)

	child: ->
		{
			false: React.DOM.a({ href: "javascript:void(0)", onClick: @linkClicked }, "Click me"),
			true: React.DOM.span({}, "You clicked the link")
		}[@state.clicked]

	render: ->
		React.DOM.div({ id:"one-time-clicked-link" }, @child())
		# unless @state.clicked
		# 	React.DOM.div(
		# 		{ id: "one-time-click-link" },
		# 		React.DOM.a(
		# 			{ href: "javascript:void(0)", onClick: @linkClicked },
		# 			"Click me"
		# 			)
		# 		)
		# else
		# 	React.DOM.div(
		# 		{id: "one-time-click-link"},
		# 		React.DOM.span({}, "You clicked the link")
		# 	)

$ ->
	ReactDOM.render(
		React.createElement(OneTimeClickLink),
		document.getElementById('react-container')
	)
