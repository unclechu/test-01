/**
 * highcharts page behavior
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\xhr-promise
	\../localization : {localization-promise : localization}
	\../utils/modal : {alert}
	\../highcharts : Highcharts
}

data-path = 'get-data.json'

(local) <-! localization.then

new xhr-promise!
.send do
	url: data-path
	method: \POST
	data: \json= + encodeURIComponent JSON.stringify do
		action: \get-statistics
		value-step: \day
		rows-limit: 30
		fields:
			\spam
			\total
			\reverts
			\complaints
.then (res)->
	if res.status isnt 200 and not res.response-text?
		throw new Error "HTTP status isn't 200"
	json = res.response-text
	json = JSON.parse json if typeof! res.response-text isnt \Object
	throw new Error "Incorrect server response data" unless json.status?
	if json.status isnt \success
		throw new Error "
			Response status is '#{json.status}'.
			#{if (typeof! json.error is \Object) and json.error.message? then " #{json.error.message}" else ''}
		"
	json
.then (json)->
	rows = json.data

	base-chart-opts =
		title: text: ''
		x-axis:
			categories:
				["#{d=new Date (..date * 1000);\
				"#{d.get-full-year!}-#{d.get-month! + 1}-#{d.get-date!}"\
				}" for rows]
		y-axis:
			min: 0

	charts =
		do
			chart:
				render-to: \chartA
				type: \line
			series:
				do
					name: local.chart-field-title.spam
					data: [..spam for rows]
				do
					name: local.chart-field-title.total
					data: [..total for rows]
		do
			chart:
				render-to: \chartB
				type: \line
			series:
				do
					name: local.chart-field-title.reverts
					data: [..reverts for rows]
				do
					name: local.chart-field-title.complaints
					data: [..complaints for rows]
		do
			title: text: local.chart-field-title.spamXtotal
			chart:
				render-to: \chartC
				type: \bar
			series:
				do
					name: local.chart-field-title.spamXtotal
					data: [Math.round(..spam * 100 / ..total) for rows]
				...
			y-axis:
				min: 0
				max: 100

	for let item in charts
		new Highcharts.Chart {} <<< base-chart-opts <<< item
.catch (e)!->
	alert do
		title: local.err.errorLabel
		messages:
			local.err.ajax.getHighchartsData
			e.message
