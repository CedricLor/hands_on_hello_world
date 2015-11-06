DOM = React.DOM

@FormInputWithLabel = React.createClass
	getDefaultProps: ->
		elementType: "input"
		inputType: "text"
	displayName: "FormInputWithLabel"
	render: ->
		classNames = "col-lg-10"
		classNames = classNames + " has-warning" if @props.warning
		DOM.div
			className: "form-group"
			DOM.label
				htmlFor: @props.id
				className: "col-lg-2 control-label"
				@props.labelText
			DOM.div
				className: classNames
				@warning
				DOM[@props.elementType]
					className: "form-control"
					placeholder: @props.placeholder
					id: @props.id
					name: @props.id
					type: @tagType()
					value: @props.value
					onChange: @props.onChange
	tagType: ->
		{
			"input": @props.inputType,
			"textarea": null
		}[@props.elementType]
	warning: ->
		return null unless @props.warning
		DOM.label
			className: "control-label"
			htmlFor: @props.id
			@props.warning