/**
 * error 404 page route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../helpers/basic-tpl-data : {get-basic-tpl-data}
	\../helpers/render-promise : {render-promise}
	co
}

export get = (app, req, res)-> co ->*
	data = yield get-basic-tpl-data
	res.status 404
	yield render-promise res, \pages/error404, {data}

export head = !-> get ... # delegate HEAD to GET
