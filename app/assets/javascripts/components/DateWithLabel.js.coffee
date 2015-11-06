DOM = React.DOM

@DateWithLabel = React.createClass
	getDefaultProps: ->
		date: new Date
	onYearChange: (event) ->
		newDate = new Date(
			event.target.value,
			@props.date.getMonth(),
			@props.date.getDate()
		)
		@props.onChange(newDate)
	onMonthChange: (event) ->
		newDate = new date(
			@props.date.getYear(),
			event.target.value,
			@props.date.getDate()
		)
		@props.onChange(newDate)
	onDateChange: (event) ->
		newDate = new date(
			@props.date.getYear(),
			@props.date.getMonth(),
			event.target.value
		)
		@props.onChange(newDate)
	dayName: (date) ->
		dayNameStartingWithSundayZero = new Date(
			@props.date.getFullYear(),
			@props.date.getMonth(),
			date
		).getDay()
		[
			"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
		][dayNameStartingWithSundayZero]
	render: ->
		DOM.div
			className: "form-group"
			DOM.label
				className: "col-lg-2 control-label"
				"Date"
			DOM.div
				className: "col-lg-2"
				DOM.select
					className: "form-control"
					onChange: @onYearChange
					value: @props.date.getFullYear()
					DOM.option(value: year, key: year, year) for year in [2015..2020]
			DOM.div
				className: "col-lg-3"
				DOM.select
					className: "form-control"
					onChange: @onMonthChange
					value: @props.date.getMonth()
					DOM.option(value: month, key: month, "#{month+1}-#{monthName(month)}") for month in [0..11]
			DOM.div
				className: "col-lg-2"
				DOM.select
					className: "form-control"
					onChange: @onDateChange
					value: @props.date.getDate()
					DOM.option(value: date, key: date, "#{date}-#{@dayName(date)}") for date in [1..31]
