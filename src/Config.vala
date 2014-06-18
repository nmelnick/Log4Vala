using Log4Vala.Appender;
using Log4Vala.Layout;
namespace Log4Vala {
	/**
	 * Provides configuration to the logging provider, handling internal
	 * configuration and parsing/monitoring configuration files.
	 */
	public class Config : Object {
		private static Config? instance;

		public HashTable<string,IAppender?> appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
		public HashTable<string,LoggerConfig?> loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );

		/**
		 * Default logging appender.
		 */
		public IAppender root_appender { get; set; }
		/**
		 * Default logging level.
		 */
		public Level root_level { get; set; }

		/**
		 * Retrieve singleton instance of Config.
		 */
		public static Config get_config() {
			if ( Config.instance == null ) {
				Config.instance = new Config();
			}
			return Config.instance;
		}

		/**
		 * Retrieve appropriate appender for the given logger name.
		 */
		public IAppender[] get_appenders_for_logger( string name ) {
			string logger_name = name;
			while ( true == true ) {
				if ( loggers.contains(logger_name) ) {
					var config = loggers.get(logger_name);
					if ( config.appenders != null ) {
						IAppender[] output_appenders = new IAppender[ config.appenders.length ];
						int index = 0;
						foreach ( var appender in config.appenders ) {
							if ( appenders.contains(appender) ) {
								output_appenders[index++] = appenders.get(appender);
							} else {
								Logger.get_logger("log4vala.internal").error(
									"No appender configured for '%s', required by logger '%s'!".printf(
										appender,
										logger_name
									)
								);
								output_appenders[index++] = root_appender;
							}
						}
						return output_appenders;
					}
				}
				var temp_name = logger_name.substring( 0, logger_name.last_index_of(".") );
				if ( logger_name == temp_name || logger_name.length == 0 ) {
					break;
				}
				logger_name = temp_name;
			}
			return { root_appender };
		}

		/**
		 * Retrieve appropriate log level for the given logger name.
		 */
		public Level get_level_for_logger( string name ) {
			string logger_name = name;
			while ( true == true ) {
				if ( loggers.contains(logger_name) ) {
					var config = loggers.get(logger_name);
					if ( config.level != null ) {
						return config.level;
					}
				}
				var temp_name = logger_name.substring( 0, logger_name.last_index_of(".") );
				if ( logger_name == temp_name || logger_name.length == 0 ) {
					break;
				}
				logger_name = temp_name;
			}
			return root_level;
		}

		internal static void reset_config() {
			instance = null;
		}

		internal Config() {
			root_appender = new ScreenAppender();
			root_appender.name = "root";
			root_appender.layout = new SimpleLayout();
			root_level = Level.TRACE;
		}
	}
}