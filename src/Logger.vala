namespace Log4Vala {
	/**
	 * Core logging class for Log4Vala, used to retrieve logger instances and
	 * perform logging within code.
	 *
	 * Usage:
	 * {{{
	 * // At the beginning of the application, or entry point for a library,
	 * // initialize Log4Vala
	 * Log4Perl.init("/path/to/log4vala.conf");
	 *
	 * // Retrieve a logger at the beginning of a module or class. The
	 * // get_logger call will always return the same object, but it might be
	 * // useful to store it in a private variable if it's class-wide.
	 * Logger logger = Log4Vala.Logger.get_logger("my.class.name");
	 *
	 * // Log a message
	 * logger.warn("Oh no, there's something off!");
	 *
	 * // Log an error
	 * try {
	 *     something_that_will_throw();
	 * } catch (Error e) {
	 *     logger.error( "Something threw!", e );
	 * }
	 * }}}
	 */
	public class Logger : Object {
		internal static HashTable<string,Logger?> logger_cache;

		/**
		 * Name of the logger instance.
		 */
		public string name { get; set; }
		/**
		 * Current log level of this instance.
		 */
		public Level log_level { get; set; }

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
				var logger = new Logger.with_name(name);
				logger.log_level = Config.get_config().get_level_for_logger(name);
				logger_cache.insert( name, logger );
				return logger;
			}
			return logger_cache.lookup(name);
		}

		/**
		 * Retrieve a Logger instance corresponding to the name of the current
		 * object class. This infers a class name from a Type name using capital
		 * letters, and may not necessarily the namespace and class name one
		 * would expect.
		 * @param object Object instance
		 */
		public static Logger get_logger_for_object( Object object ) {
			string name;
			if ( Config.get_config().translate_type_name ) {
				var regex = /(.)([A-Z])/;
				name = regex.replace( object.get_type().name(), -1, 0, "\\1.\\2" );
			} else {
				name = object.get_type().name();
			}
			return get_logger(name);
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

			// get appenders
			var appenders = Config.get_config().get_appenders_for_logger(name);
			foreach ( var appender in appenders ) {
				appender.append(log_event);
			}
		}

		/**
		 * Log asynchronously, if in a runloop or event loop.
		 *
		 * For example, log_async.begin( LogLevel.DEBUG, "Test Message" );
		 * @param log_level Level to log at
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void log_async( Level log_level, string message, Error? e = null ) {
			log( log_level, message, e );
		}

		/**
		 * Log a trace message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void trace_async( string message, Error? e = null ) {
			log( Level.TRACE, message, e );
		}

		/**
		 * Log a debug message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void debug_async( string message, Error? e = null ) {
			log( Level.DEBUG, message, e );
		}

		/**
		 * Log an info message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void info_async( string message, Error? e = null ) {
			log( Level.INFO, message, e );
		}

		/**
		 * Log a warning message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void warn_async( string message, Error? e = null ) {
			log( Level.WARN, message, e );
		}

		/**
		 * Log an error message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void error_async( string message, Error? e = null ) {
			log( Level.ERROR, message, e );
		}

		/**
		 * Log a fatal message via log(), asynchronously.
		 * @param message Message to log
		 * @param e Optional Error object to log
		 */
		public async void fatal_async( string message, Error? e = null ) {
			log( Level.FATAL, message, e );
		}

	}
}