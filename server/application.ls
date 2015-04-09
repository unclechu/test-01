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
}

co ->*
	cfg = yield config

	app = express!
		.engine \jade, jade.__express
		.use express-promise!

		.use /^\/static\//,\
			express.static path.resolve process.cwd!, cfg.STATIC_PATH

	methods = <[head get post]>

	{PORT, HOST} = cfg.SERVER

	http
		.create-server app
