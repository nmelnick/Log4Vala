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
		FATAL;

		/**
		 * Retrieve friendly name for log level. For example, Level.TRACE would
		 * return "TRACE".
		 */
		public string friendly() {
			return this.to_string().substring(16);
		}

		/**
		 * Retrieve Level value by string name. For example, "trace" would
		 * return Level.TRACE.
		 * @param name Name of value
		 */
		public static Level? get_by_name( string name ) {
			var class = (EnumClass) typeof(Level).class_ref();
			unowned EnumValue? eval = class.get_value_by_name( "LOG4_VALA_LEVEL_" + name.up() );
			if ( eval != null ) {
				return (Level) eval.value;
			}
			return null;
		}
	}
}