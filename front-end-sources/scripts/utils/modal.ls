/**
 * modal abstraction modul
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	jquery: $
	\bootstrap-modal
}

export alert = ({title='...', messages=['...']})->
	messages = messages |> (.map -> "<p>#{it}</p>")

	<-! $ \#alertModal .each
	$ @ .find \.modal-title .text title
	$ @ .find \.modal-body .html messages
	$ @ .modal!
