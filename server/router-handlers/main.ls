/**
 * main route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	\../utils : {logger, get-basic-tpl-data}
	co
}

module.exports.get = (app, req, res)-> co ->*
	cfg = yield config
	data = {} <<< (get-basic-tpl-data cfg)
	yield new Promise (resolve, reject) !->
		res.render \pages/main, data, (err, html)!->
			return reject err if err?
			res.end html
			resolve!

module.exports.head = !->
	# delegate HEAD to GET
	module.exports.get ...
