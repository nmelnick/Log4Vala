namespace Log4Vala {
	/**
	 * Provides deprecated method compatibility without cluttering the Logger
	 * class.
	 */
	public interface LoggerCompat {
		/**
		 * Log a trace message, with formatting, via log().
		 * @param message Message to log
		 */
		public void trace_format( string message, ...  ) {
			var l = va_list();
			log( Level.TRACE, message.vprintf(l) );
		}

		/**
		 * Log a debug message, with formatting, via log().
		 * @param message Message to lo
		 */
		public void debug_format( string message, ... ) {
			var l = va_list();
			log( Level.DEBUG, message.vprintf(l) );
		}

		/**
		 * Log an info message, with formatting, via log().
		 * @param message Message to log
		 */
		public void info_format( string message, ... ) {
			var l = va_list();
			log( Level.INFO, message.vprintf(l) );
		}

		/**
		 * Log a warning message, with formatting, via log().
		 * @param message Message to log
		 */
		public void warn_format( string message, ... ) {
			var l = va_list();
			log( Level.WARN, message.vprintf(l) );
		}

		/**
		 * Log an error message, with formatting, via log().
		 * @param message Message to log
		 */
		public void error_format( string message, ... ) {
			var l = va_list();
			log( Level.ERROR, message.vprintf(l) );
		}

		/**
		 * Log a fatal message, with formatting, via log().
		 * @param message Message to log
		 */
		public void fatal_format( string message, ... ) {
			var l = va_list();
			log( Level.FATAL, message.vprintf(l) );
		}

		public abstract void log( Level log_level, string message, Error? e = null );
	}
}