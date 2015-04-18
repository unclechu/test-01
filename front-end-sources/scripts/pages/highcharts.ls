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
}

data-path = 'get-data.json'

(local) <-! localization.then

new xhr-promise!
.send do
	url: data-path
	method: \POST
.then (res)->
	throw new Error "HTTP status isn't 200" if res.status isnt 200
	json = res.response-text
	json = JSON.parse json if typeof! res.response-text isnt \Object
	throw new Error "Incorrect server response data" unless json.status?
	throw new Error "Response status is '#{json.status}'" if json.status isnt \success
	json
.then (json)->
	console.log json
	throw new Error ''
.catch (e)!->
	alert do
		title: local.err.errorLabel
		messages:
			local.err.ajax.getHighchartsData
			e.message
