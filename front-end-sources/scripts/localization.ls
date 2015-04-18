/**
 * localization module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\xhr-promise
	\./utils/modal : {alert}
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
	.catch (e)!->
		if e instanceof LocalizationLoadError
			alert do
				title: \Error
				messages:
					switch
					| e.exception? => [e.message, e.exception.message]
					| _ => [e.message]
		else
			e = new LocalizationLoadError null, {exception: e}
			alert do
				title: \Error
				messages: [e.message]
		throw e
