namespace Log4Vala {
	/**
	 * Log levels for configuration or output.
	 *
	 * There are six predefined log levels, in order of severity, from least
	 * to most: TRACE, DEBUG, INFO, WARN, ERROR, and FATAL. The configured log
	 * level will transfer messages of that level or greater. For example, if
	 * the configured level is INFO, then messages logged as INFO, WARN, ERROR,
	 * and FATAL will be dispatched.
	 */
	public enum Level {
		TRACE,
		DEBUG,
		INFO,
		WARN,
		ERROR,
		FATAL
	}
}