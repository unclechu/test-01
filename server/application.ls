/**
 * main application module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\./config : {config}
	express
	jade
	\express-promise
	path
	\./utils : {logger}
	http
	co
	\./router
	\body-parser
	\./helpers/mysql-promise : mysql
}

co ->*
	cfg = yield config

	logger.level = \debug if cfg.DEBUG

	yield mysql.open!

	logger.debug 'application.ls',\
		"Express.js application instance initialization..."
	app = express!
		.use body-parser.urlencoded extended: yes
		.use body-parser.json!
		.engine \jade, jade.__express
		.use express-promise!
		.set \views, path.resolve process.cwd!, cfg.TEMPLATES_PATH
		.set 'view engine', \jade
		.use /^\/static/,\
			express.static path.resolve process.cwd!, cfg.STATIC_PATH

	{PORT, HOST} = cfg.SERVER

	router.init app

	logger.debug 'application.ls',\
		"Trying to start http-server at http://#{HOST}:#{PORT}..."

	yield new Promise (resolve, reject)!->
		http
		.create-server app
		.on \error, !->
			logger.error 'application.ls',\
				"Can't start http-server at http://#{HOST}:#{PORT}", it
			reject it
		.listen PORT, HOST, !->
			resolve!

	logger.info 'application.ls',\
		"http-server started at http://#{HOST}:#{PORT}"

.catch !->
	logger.error 'application.ls:catch()',\
		"Application initialization error", it
	mysql.close!
	.catch !-> # ignore error
	.then !-> process.exit 1
