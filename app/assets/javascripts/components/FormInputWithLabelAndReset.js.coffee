DOM = React.DOM

@FormInputWithLabelAndReset = React.createClass
	displayName: "FormInputWithLabelAndReset"
	render: ->
		DOM.div
			className: "form-group"
			DOM.label
				htmlFor: @props.id
				className: "col-lg-2 control-label"
				@props.labelText
			DOM.div
				className: "col-lg-8"
				DOM.div
					className: "input-group"
					DOM.input
						className: "form-control"
						placeholder: @props.placeholder
						id: @props.id
						name: @props.id
						value: @props.value
						onChange: (event) =>
							@props.onChange(event.target.value)
					DOM.span
						className: "input-group-btn"
						DOM.button
							onClick: () =>
								@props.onChange(null)
							className: "btn btn-default"
							type: "button"
							DOM.i
								className: "fa fa-magic"
						DOM.button
							onClick: () =>
								@props.onChange("")
							className: "btn btn-default"
							type: "button"
							DOM.i
								className: "fa fa-times-circle"
