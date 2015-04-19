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
	\prelude-ls : {filter, map, reverse}
}

# helper for handle errors
handle-err = (app, req, res, {
	status = 400
	logmsg = "Handled request error."
	error = {} # response 'error' key to extend
	exception = null
	addit-log-info = null # must be an array or null
})!->
	retval =
		status: \error
		error: error
	logger.error 'get-data.ls:get-statistics()',\
		"#{logmsg}
		\nURL: #{req.original-url};
		\nStatus: #{status};
		\nRequest data: '#{inspect req.body, depth: 3}';
		#{if addit-log-info? then "\n#{addit-log-info.join ';\n'};" else ''}
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
	max-limit = 30

	limit = req.body.rows-limit
	limit = max-limit unless limit?
	limit = parse-int limit, 10
	if "#limit" isnt "#{req.body.rows-limit}" or limit <= 0
		return handle-err app, req, res, error:
			code: \get-statistics-incorrect-rows-limit
			message: "Incorrect rows limit value type (must be an unsigned integer)"
	if limit > max-limit
		return handle-err app, req, res, error:
			code: \get-statistics-rows-limit-over-max
			message: "Rows limit maximum is #{max-limit}"

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

	# if fields list is empty then select all available fields
	fields = [] ++ fields-white-list if fields.length <= 0

	# wrap fields to AVG() func
	q-fields = fields |> map (-> "AVG(#{it}) as #{it}")

	# query to database
	q = """
		SELECT UNIX_TIMESTAMP(DATE(dt)) as date,#{fields.join \,} FROM statistics
		GROUP BY #{
			switch req.body.value-step
			| \day => 'DATE(dt)'
			| otherwise => ...
		}
		ORDER by dt DESC
		LIMIT #{limit};
	"""

	try
		{rows} = yield mysql.query q
		rows |>= reverse # restore ASC sort
	catch
		return handle-err app, req, res, do
			status: 500
			error:
				code: \get-statistics-db-error
				message: "Database error"
			exception: e
			addit-log-info: ["DB query: '''\n#{q}\n'''"]

	res.status 200 .json do
		status: \success
		data: rows

# WARN :: values must return promises
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
