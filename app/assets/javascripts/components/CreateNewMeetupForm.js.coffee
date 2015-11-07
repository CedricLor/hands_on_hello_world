DOM = React.DOM

@CreateNewMeetupForm = React.createClass
	displayName: "CreateNewMeetupForm"
	getInitialState: -> 
		{
			meetup: {
				title: ""
				description: ""
				date: new Date()
				seoText: null
				guests: [""]
				warnings: {
					title: null
				},				
			}
		}

	dateChanged: (newDate) ->
		@state.meetup.date = newDate
		@forceUpdate()

	fieldChanged: (event) ->
		inputText = event.target.value
		fieldName = event.target.name
		@state.meetup[fieldName] = inputText
		@validateField(fieldName)
		@forceUpdate()

	validateField: (fieldName) ->
		validator = {
			title: (text) ->
				if /\S/.test(text) then null else "cannot be blank"
		}[fieldName]
		return unless validator
		@state.meetup.warnings[fieldName] = validator( @state.meetup[fieldName] )

	seoChanged: (seoText) ->
		@state.meetup.seoText = seoText
		@forceUpdate()

	computeDefaultSeoText: () ->
		words = @state.meetup.title.split(/\s+/)
		words.push(monthName(@state.meetup.date.getMonth()))
		words.push(@state.meetup.date.getFullYear().toString())
		words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

	guestEmailChanged: (indexNumber, event) ->
		guests = @state.meetup.guests
		guests[indexNumber] = event.target.value

		lastEmail = guests[guests.length-1]
		penultimateEmail = guests[guests.length-2]

		if (lastEmail != "")
			guests.push("")
		if (guests.length >= 2 && lastEmail == "" && penultimateEmail == "")
			guests.pop()

		@forceUpdate()			

	validateAll: () ->
		for field in ['title']
			@validateField(field)

	formSubmitted: (event) ->
		event.preventDefault()

		console.log(@state.meetup)

		@validateAll()
		@forceUpdate()

		for own key of @state.meetup
			return if @state.meetup.warnings[key]

		$.ajax
			url: "/meetups.json",
			type: "post",
			dataType: "json",
			contentType: "application/json",
			processData: false,
			data: JSON.stringify({meetup: {
				title: @state.meetup.title
				description: @state.meetup.description
				date: [
					@state.meetup.date.getFullYear(),
					@state.meetup.date.getMonth()+1,
					@state.meetup.date.getDate()
				].join("-")
				seo: @state.meetup.seoText || @computeDefaultSeoText()
				guests: @state.meetup.guests

			}})

	render: ->
		DOM.form
			className: "form-horizontal"
			method: "post",
			action: "/meetups"
			DOM.fieldset null,
				DOM.legend null, "New Meetup"

				React.createElement FormInputWithLabel, id: "title", onChange: @fieldChanged, value: @state.meetup.title, placeholder: "Meetup title", labelText: "Title", warning: @state.meetup.warnings.title
				React.createElement FormInputWithLabel, id: "description", onChange: @fieldChanged, value: @state.meetup.description, placeholder: "Meetup description", labelText: "Description", elementType: "textarea"
				React.createElement DateWithLabel, onChange: @dateChanged, date: @state.meetup.date
				React.createElement FormInputWithLabelAndReset, id: "seo", onChange: @seoChanged, value: (if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSeoText()), placeholder: "SEO Text", labelText: "seo"

				DOM.div
					className: "form-group"
					DOM.div
						className: "col-lg-10 col-lg-offset-2"
						DOM.button
							type: "button"
							className: "btn btn-primary"
							onClick: @formSubmitted
							"Save"

			DOM.fieldset null,
				DOM.legend null, "Guests"
				React.createElement(
					Separator
					{}
					for guest, n in @state.meetup.guests

						React.createElement FormInputWithLabel, id: "email_#{n}", key: "guests-#{n}", onChange: @guestEmailChanged.bind(null, n), value: guest, placeholder: "Email address of invitee", labelText: "Email", inputType: "email"
				)
