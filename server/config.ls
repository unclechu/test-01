/**
 * config getter module
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\js-yaml : yaml
	\mz/fs : {read-file}
	path
	\./utils : {logger}
}

config-file-path = path.resolve process.cwd!, \config.yaml

export config =
	read-file config-file-path, \utf8
	.then -> yaml.safe-load it
	.catch !->
		logger.error 'config.ls:config{}',\
			"Cannot parse YAML config file: '#{config-file-path}'", it
		throw it # just log and throw to next catch
