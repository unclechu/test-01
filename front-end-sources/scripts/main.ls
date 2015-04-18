/**
 * main module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

<-! document.add-event-listener \DOMContentLoaded

require! {
	\./highcharts
	\./utils/has-class : {has-class}
}

html = document.query-selector-all 'html' .0

switch
| html `has-class` \highcharts-page => require \./pages/highcharts
