/**
 * utils module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	winston: {Logger, transports: logger-transports}
	util: {inspect}
	path
}

revision = new Date! .get-time!

module.exports.logger = new Logger do
	transports:
		new logger-transports.Console do
			colorize: \all
			timestamp: on
		...

module.exports.get-basic-tpl-data = (cfg)-> do
	lang: \ru
	static-url: (relative-path)->
		path.join \/static/, relative-path |> (+ "?v=#revision")
	inspect: (smth, opts=null)-> inspect smth, opts
	charset: \utf-8
