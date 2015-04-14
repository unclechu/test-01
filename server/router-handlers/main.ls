/**
 * main route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../helpers/basic-tpl-data : {get-typical-page-data}
	\../helpers/render-promise : {render-promise}
	co
}

export get = (app, req, res)-> co ->*
	data = {} <<< (yield get-typical-page-data app, req)
	yield render-promise res, \pages/main, {data}

export head = !-> get ... # delegate HEAD to GET
