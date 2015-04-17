/**
 * error 404 page route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	\../helpers/basic-tpl-data : {get-typical-page-data}
	\../helpers/render-promise : {render-promise}
	co
}

export get = (app, req, res)-> co ->*
	cfg = yield config
	data = {} <<< (yield get-typical-page-data app, req)
	res.status 404
	yield render-promise res, "pages/#{cfg.LANG}/error404", {data}

export head = !-> get ... # delegate HEAD to GET
