DOM = React.DOM

class @CreateNewMeetup
	constructor: (@element) ->
		@meetup = {
			title: ""
			description: ""
			date: new Date()
			seoText: null
			warnings: {
				title: null
			},			
		}

	dateChanged: (newDate) ->
		@meetup.date = newDate
		@render()

	fieldChanged: (event) ->
		inputText = event.target.value
		fieldName = event.target.name
		@meetup[fieldName] = inputText
		@validateField(fieldName)
		@render()

	validateField: (fieldName) ->
		validator = {
			title: (text) ->
				if /\S/.test(text) then null else "cannot be blank"
		}[fieldName]
		return unless validator
		@meetup.warnings[fieldName] = validator( @meetup[fieldName] )

	seoChanged: (seoText) ->
		@meetup.seoText = seoText # note: there was a bug seotText was written setText
		@render()

	validateAll: () ->
		for field in ['title']
			@validateField(field)
	# validateAll: (newState) : newState was not to be passed in the mutable way (prior version on github); it is of no use

	formSubmitted: (event) ->
		event.preventDefault()

		@validateAll()
		@render()

		for own key of @state.meetup
			return if @state.meetup.warnings[key]

		$.ajax
			url: "/meetups.json",
			type: "post",
			dataType: "json",
			contentType: "application/json",
			processData: false,
			data: JSON.stringify({meetup: {
				title: @meetup.title,
				description: @meetup.description,
				date: [
					@meetup.date.getFullYear(),
					@meetup.date.getMonth()+1,
					@meetup.date.getDate()
				].join("-")
				seo: @smeetup.seoText
			}})

	render: () ->
		virt_element = React.createElement CreateNewMeetupForm, meetup = @meetup, fieldChanged: @fieldChanged.bind(@), dateChanged: @dateChanged.bind(@), seoChanged: @seoChanged.bind(@), formSubmitted: @formSubmitted.bind(@)
		ReactDOM.render(virt_element, @element)


@CreateNewMeetupForm = React.createClass
	displayName: "CreateNewMeetupForm"

	computeDefaultSeoText: () ->
		words = @props.title.split(/\s+/)
		words.push(monthName(@props.date.getMonth()))
		words.push(@props.date.getFullYear().toString())
		words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

	render: () ->
		DOM.form
			className: "form-horizontal"
			# method: "post",
			# action: "/meetups"
			DOM.fieldset null,
				DOM.legend null, "New Meetup"

				React.createElement FormInputWithLabel, id: "title", onChange: @props.children.fieldChanged, value: @props.title, placeholder: "Meetup title", labelText: "Title", warning: @props.warnings.title
				React.createElement FormInputWithLabel, id: "description", onChange: @props.children.fieldChanged, value: @props.description, placeholder: "Meetup description", labelText: "Description", elementType: "textarea"
				React.createElement DateWithLabel, onChange: @props.children.dateChanged, date: @props.date
				React.createElement FormInputWithLabelAndReset, id: "seo", onChange: @props.children.seoChanged, value: (if @props.seoText? then @props.seoText else @computeDefaultSeoText()), placeholder: "SEO Text", labelText: "seo"

				DOM.div
					className: "form-group"
					DOM.div
						className: "col-lg-10 col-lg-offset-2"
						DOM.button
							type: "button"
							className: "btn btn-primary"
							onClick: @props.children.formSubmitted
							"Save"

