DOM = React.DOM

@CreateNewMeetupForm = React.createClass
	displayName: "CreateNewMeetupForm"
	getInitialState: -> 
		{
			title: ""
			description: ""
			date: new Date()
			seoText: null
			warnings: {
				# text: null
			},
		}

	dateChanged: (newDate) ->
		@setState(date: newDate)

	fieldChanged: (event) ->
		newState = $.extend(true, {}, @state)
		inputText = event.target.value
		fieldName = event.target.name
		newState[fieldName] = inputText
		newState['warnings']["#{fieldName}"] = @validateField(fieldName, inputText)
		@setState(newState)

		# @validateField(event.target.name, event.target.value)
		# @setState "#{event.target.name}": event.target.value

	validateField: (fieldName, value) ->
		validator = {
			title: (text) ->
				if /\S/.test(text) then null else "cannot be blank"
		}[fieldName]
		return unless validator
		validator(value)
		# warnings = @state.warnings
		# warnings[fieldName] = validator(value)
		# @setState(warnings: warnings)

	seoChanged: (seoText) ->
		@setState(seoText: seoText)

	computeDefaultSeoText: () ->
		words = @state.title.toLowerCase().split(/\s+/)
		words.push(monthName(@state.date.getMonth()))
		words.push(@state.date.getFullYear().toString())
		words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

	validateAll: (newState) ->
		for field in ['title']
			newState['warnings'][field] = @validateField(field, newState[field])
		newState

	formSubmitted: (event) ->
		event.preventDefault()
		newState = @validateAll( $.extend(true, {}, @state) )
		@setState(newState)
		for own key of newState.warnings
			return if newState.warnings[key]
		$.ajax
			url: "/meetups.json",
			type: "post",
			dataType: "json",
			contentType: "application/json",
			processData: false,
			data: JSON.stringify({meetup: {
				title: @state.title,
				description: @state.description,
				date: "#{@state.date.getFullYear()}-#{@state.date.getMonth()+1}-#{@state.date.getDate()}",
				seo: @state.seoText || @computeDefaultSeoText()
			}})

	render: ->
		DOM.form
			className: "form-horizontal"
			method: "post",
			action: "/meetups"
			DOM.fieldset null,
				DOM.legend null, "New Meetup"

				React.createElement FormInputWithLabel, id: "title", onChange: @fieldChanged, value: @state.title, placeholder: "Meetup title", labelText: "Title", warning: @state.warnings.title
				React.createElement FormInputWithLabel, id: "description", onChange: @fieldChanged, placeholder: "Meetup description", labelText: "Description", elementType: "textarea"
				React.createElement DateWithLabel, onChange: @dateChanged, date: @state.date
				React.createElement FormInputWithLabelAndReset, id: "seo", onChange: @seoChanged, value: (if @state.seoText? then @state.seoText else @computeDefaultSeoText()), placeholder: "SEO Text", labelText: "seo"

				DOM.div
					className: "form-group"
					DOM.div
						className: "col-lg-10 col-lg-offset-2"
						DOM.button
							type: "button"
							className: "btn btn-primary"
							onClick: @formSubmitted
							"Save"
