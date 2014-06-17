namespace Log4Vala {
	public class Logger : Object {
		internal static HashTable<string,Logger?> logger_cache;

		/**
		 * Name of the logger instance.
		 */
		public string name { get; set; }
		/**
		 * Current log level of this instance.
		 */
		public Level log_level { get; set; default = Level.TRACE; }

		/**
		 * Retrieve a Logger instance corresponding to the name of the logger.
		 * Subsequent calls with the same name will return the same Logger
		 * object.
		 * @param name Name of the logger. For example, "log4vala.logger".
		 */
		public static Logger get_logger( string name ) {
			if ( logger_cache == null ) {
				logger_cache = new HashTable<string,Logger?>( str_hash, str_equal );
			}
			if ( ! logger_cache.contains(name) ) {
				// Config, etc
				var logger = new Logger.with_name(name);
				logger_cache.insert( name, logger );
			}
			return logger_cache.lookup(name);
		}

		internal Logger() {}

		internal Logger.with_name( string name ) {
			this.name = name;
		}

		/**
		 * Log a trace message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void trace( string message, Error? e = null ) {
			log( Level.TRACE, message, e );
		}

		/**
		 * Log a debug message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void debug( string message, Error? e = null ) {
			log( Level.DEBUG, message, e );
		}

		/**
		 * Log an info message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void info( string message, Error? e = null ) {
			log( Level.INFO, message, e );
		}

		/**
		 * Log a warning message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void warn( string message, Error? e = null ) {
			log( Level.WARN, message, e );
		}

		/**
		 * Log an error message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void error( string message, Error? e = null ) {
			log( Level.ERROR, message, e );
		}

		/**
		 * Log a fatal message via log().
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void fatal( string message, Error? e = null ) {
			log( Level.FATAL, message, e );
		}

		/**
		 * Core logging method.
		 * @param log_level Level to log at
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public void log( Level log_level, string message, Error? e = null ) {
			if ( log_level < this.log_level ) {
				return;
			}

			// create a logevent
			var log_event = new LogEvent.with_message(
				name,
				log_level,
				message,
				e
			);

			// get a layout
			log_event.layout = new Layout.SimpleLayout();
			
			// get an appender
			var appender = new Appender.ScreenAppender();

			// replace this
			appender.append(log_event);
		}

	}
}