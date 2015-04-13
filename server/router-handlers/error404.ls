/**
 * error 404 page route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	\../utils : {get-basic-tpl-data, render-promise}
	co
}

module.exports.get = (app, req, res)-> co ->*
	cfg = yield config
	data = {} <<< (get-basic-tpl-data cfg)
	res.status 404
	yield render-promise res, \pages/error404, {data}

module.exports.head = !->
	# delegate HEAD to GET
	module.exports.get ...
