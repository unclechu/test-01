/**
 * get json data route handler
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	co
}

export post = (app, req, res)-> co ->*
	cfg = yield config
	res.status 200 .end do
		status: \success
