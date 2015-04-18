/**
 * localization module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\xhr-promise
}

html = document.query-selector-all 'html' .0
lang = html.get-attribute \lang
localization-path = html.get-attribute \data-localization-path

export class LocalizationLoadError extends Error
	(
		message = "Cannot load localization file by path: '#{localization-path}'."
		{exception = null}
	)!->
		@message = message
		@exception = exception

export localization-promise =
	new xhr-promise!
	.send url: localization-path
	.then (res)->
		throw new LocalizationLoadError! if res.status isnt 200
		try
			return res.response-text[lang]
		catch
			throw new LocalizationLoadError \
				"Get get localization by lang: '#{lang}'", {exception: e}
	.catch !->
		if it instanceof LocalizationLoadError
			window.alert it.message \
				+ if it.exception? then "\n\n#{it.exception.message}" else ''
			throw it
		else
			e = new LocalizationLoadError null, {exception: it}
			window.alert e.message
			throw e
