/**
 * basic template data generator (promise)
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config : {config}
	util: {inspect}
	path
	co
}

revision = new Date! .get-time!

export get-basic-tpl-data = co ->*
	cfg = yield config
	localization = require path.resolve \
		process.cwd!, cfg.STATIC_PATH, \localization.json
	unless localization[cfg.LANG]?
		throw new Error "Localization by LANG '#{cfg.LANG}' not found"
	data =
		lang: cfg.LANG
		static-url: (relative-path)->
			path.join \/static/, relative-path |> (+ "?v=#revision")
		inspect: (smth, opts=null)-> inspect smth, opts
		charset: \utf-8
		local: localization[cfg.LANG]
	return data

# TODO
export get-menus = -> co ->*
	menus =
		main-menu: null

	#...
