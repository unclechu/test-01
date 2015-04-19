/**
 * get json data route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../helpers/mysql-promise : mysql
	\../config : {config}
	\../utils : {logger}
	util: {inspect}
	co
	\prelude-ls : {filter}
}

# helper for handle errors
handle-err = (app, req, res, {
	status = 400
	logmsg = "Handled request error."
	error = {} # response 'error' key to extend
	exception = null
})!->
	retval =
		status: \error
		error: error
	logger.error 'get-data.ls:get-statistics()',\
		"#{logmsg}
		\nURL: #{req.original-url};
		\nStatus: #{status};
		\nRequest data: '#{inspect req.body, depth: 3}';
		\nResponse: '#{inspect retval, depth: 3}'
		#{if exception? then "\nException:" else '.'}", exception
	res.status status .json retval

export get-statistics = (app, req, res)-> co ->*
	value-step-white-list =
		\day
		...
	fields-white-list =
		\spam
		\total
		\reverts
		\complaints

	# value step validation
	unless req.body.value-step in value-step-white-list
		return handle-err app, req, res, error:
			code: \get-statistics-value-step-map
			message: "This value step isn't available"

	fields = req.body.fields
	fields = [] ++ fields-white-list unless fields? # clone white list

	# fields list type validation
	if typeof! fields isnt \Array
		return handle-err app, req, res, error:
			code: \get-statistics-incorrect-fields-list
			message: "Incorrect fields list type"

	# fields list validation
	out-of-list-fields = fields |> filter (-> it in fields-white-list |> (not))
	if out-of-list-fields.length > 0
		return handle-err app, req, res, error:
			code: \get-statistics-unavailable-fields
			message: "Unavailable fields"
			fields: out-of-list-fields

	# TODO :: request to database
	res.status 200 .json do
		status: \success
		data: [1 2 3]

actions-map =
	\get-statistics : get-statistics

export post = (app, req, res)-> co ->*
	logger.debug 'get-data.ls:post()',\
		"Handled request.
		\nURL: #{req.original-url};
		\nRequest data: '#{inspect req.body, depth: 3}'."

	# action mapping
	try
		return actions-map[req.body.action] app, req, res
	catch
		return handle-err app, req, res, do
			error:
				code: \action-map
				message: "This action isn't available"
			exception: e
