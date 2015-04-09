/**
 * utils module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	winston: {Logger, transports: logger-transports}
}

module.exports.logger = new Logger do
	transports:
		new logger-transports.Console do
			colorize: \all
			timestamp: on
		...
