/**
 * mysql promise wrapper
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	\../utils : {logger}
	mysql
	\prelude-ls : {Obj}
}

instance = null

export open = -> new Promise (resolve, reject)!->
	(cfg) <-! config.then

	{
		PORT
		SOCKET_PATH: SOCKET
		HOST
		USER
		PASSWORD: PASS
		DATABASE_NAME: DBNAME
	} = cfg.DATABASE

	logger.debug 'mysql-promise.ls:open()',\
		"Opening MySQL connection..."

	db-config =
		do
			port: PORT
			socket-path: SOCKET
			host: HOST
			user: USER
			password: PASS
			database: DBNAME
		|> Obj.filter (-> it?)

	connection = mysql.create-connection db-config

	(err) <-! connection.connect

	if err?
		logger.error 'mysql-promise.ls:open()',\
			"Cannot open MySQL connection", err
		reject err
		return

	instance := connection
	logger.info 'mysql-promise.ls:open()',\
		"MySQL connection is opened"
	resolve!

export close = -> new Promise (resolve, reject)!->
	unless instance?
		e = new Error "MySQL connection isn't opened"
		logger.error 'mysql-promise.ls:close()', e.message
		reject e
		return

	logger.debug 'mysql-promise.ls:close()',\
		"Closing MySQL connection..."

	(err) <-! instance.end

	if err?
		logger.error 'mysql-promise.ls:close()',\
			"Cannot close MySQL connection", err
		reject err
		return

	instance := null
	logger.info 'mysql-promise.ls:close()',\
		"MySQL connection is closed"
	resolve!

export query = (q)-> new Promise (resolve, reject)!->
	unless instance?
		e = new Error "MySQL connection isn't opened"
		logger.error 'mysql-promise.ls:query()', e.message
		reject e
		return

	logger.debug 'mysql-promise.ls:query()',\
		"MySQL query: '''\n#{q}\n'''..."

	(err, rows, fields) <-! instance.query q

	if err?
		logger.error 'mysql-promise.ls:query()',\
			"MySQL query error: '#{q}'", err
		reject err
		return

	resolve {rows, fields}
