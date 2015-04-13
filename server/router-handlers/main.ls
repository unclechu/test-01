/**
 * main route handler
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

export get = (app, req, res)-> co ->*
	cfg = yield config
	data = {} <<< (get-basic-tpl-data cfg)
	yield render-promise res, \pages/main, {data}

export head = !-> get ... # delegate HEAD to GET
