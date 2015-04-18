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
	\prelude-ls : {obj-to-pairs, map, pairs-to-obj}
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
		static-url: (relative-path='')->
			path.join \/static/, relative-path
				|> (+ if !!relative-path then "?v=#revision" else '')
		inspect: (smth, opts=null)-> inspect smth, opts
		charset: \utf-8
		local: localization[cfg.LANG]
	return data

is-active-menu-item = (url, link)->
	active = (url.index-of link) is 0
	current = active and link is url
	active = false if (link is '/') and (url isnt '/')
	{active, current}

rel-url = (base-url, rel-path)->
	return rel-path if (rel-path.char-at 0) isnt '/'
	base-url = base-url or \/
	path.join base-url, rel-path.slice 1

export get-menus = (req)-> co ->*
	cfg = yield config

	menus =
		main: (require path.resolve \
			process.cwd!, cfg.STATIC_PATH, \main-menu.json)[cfg.LANG]

	menus = menus
		|> obj-to-pairs
		|> map (menu)->
			menu.1 |> map ->
				is-active = is-active-menu-item req.original-url, it.href
				{it.active, it.current} = is-active
				it.href = rel-url req.base-url, it.href
				it
			menu
		|> pairs-to-obj

	return {menu: menus}

export get-typical-page-data = (app, req)-> co ->*
	data = {} <<< (yield get-basic-tpl-data) <<< (yield get-menus req)
	return data
