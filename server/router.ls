/**
 * application router
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\./config : {config}
	\./utils : {logger}
	\prelude-ls : {filter, map, each, Obj, obj-to-pairs, pairs-to-obj, camelize}
	co
}

methods = <[head get post]> # for handlers methods filtering

/**
 * handlers list
 * a handler item is object -- {method-name: handler-callback}
 */
handlers =
	# list of route handlers modules
	<[
		main
		error404
	]>

	# require modules
	|> map (-> [(it |> camelize), (require "./router-handlers/#it")])
	|> pairs-to-obj

	# filtering routers methods
	|> Obj.map ->
		it
		|> obj-to-pairs
		|> filter (-> it.0 in methods)
		|> pairs-to-obj

routes = [
	* /^\/$/, handlers.main
	* \*, handlers.error404
]

bind-all-methods = (app, url, handler)!-->
	logger.debug 'router.ls:bind-all-methods()',\
		"Binding handler for url: '#{url}'"
	handler # {method-name: handler-callback}
	|> obj-to-pairs
	|> each (h)!->
		app[h.0] url, (req, res)!-> co ->*
			cfg = yield config

			# logging
			logger.debug 'router.ls:bind-all-methods()',\
				"Handled '#{h.0}' request by url: '#{req.original-url}'"

			# delegate to handler callback
			h.1 app, req, res
			.catch !->
				logger.error 'router.ls:bind-all-methods()',\
					"Handled error of '#{h.0}'
					\ request by url: '#{req.original-url}'", it
				if cfg.DEBUG
					throw it
				else
					throw new Error '500 Internal Server Error'
			.catch !->
				res.status 500 .end it.message

module.exports.init = (app)-> co ->*
	logger.debug 'router.ls:module.exports.init()',\
		"Router initialization..."

	# routing
	routes |> each (!-> bind-all-methods app, it.0, it.1)

	logger.debug 'router.ls:module.exports.init()',\
		"Router is initialized"
