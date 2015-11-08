DOM = React.DOM

@Separator = React.createClass
	displayName: "Separator"
	render: () ->
		children = []
		for child, i in @props.children
			children.push( child )
			if i < @props.children.length - 1
				children.push(
					DOM.div
						key: "separator-#{i}"
						className: "col-lg-offset-2 col-lg-10"
						DOM.hr
							className: "form-input-separator"
				)
		DOM.div(null, children)