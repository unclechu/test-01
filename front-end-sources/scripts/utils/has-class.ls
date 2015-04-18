/**
 * has-class util
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

export has-class = (el, find-class)->
	!!~(" #{el.class-name} ".index-of " #{find-class} ")
