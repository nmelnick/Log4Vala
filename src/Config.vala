using Log4Vala.Appender;
using Log4Vala.Layout;
namespace Log4Vala {
	/**
	 * Provides configuration to the logging provider, handling internal
	 * configuration and parsing/monitoring configuration files.
	 */
	public class Config : Object {
		private static Config? instance;

		private FileMonitor monitor;

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
		 * Path to configuration file.
		 */
		public string config_file { get; set; }

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

		/**
		 * Parse or re-parse configuration file stored in config_file. This will
		 * clear the existing configuration.
		 */
		public void parse_config() {
			var file = File.new_for_path(config_file);
			if ( ! file.query_exists() ) {
				Logger.get_logger("log4vala.internal").error(
					"Config file '%s' does not exist".printf(config_file)
				);
				return;
			}

			set_defaults();

			try {
				var dis = new DataInputStream( file.read() );
				string line;
				while ( (line = dis.read_line(null) ) != null ) {
					parse_config_line( ref line );
				}
			} catch (Error e) {
				Logger.get_logger("log4vala.internal").error(
					"Unable to open or read config file '%s'!".printf(config_file),
					e
				);
			}
		}

		public void parse_config_line( ref string line_to_parse ) {
			// Kill off spacing, skip empty lines and comments
			var line = line_to_parse.strip();
			if ( line.has_prefix("#") || line.length == 0 ) {
				return;
			}

			// Start the parse
			var key = line.substring( 0, line.index_of("=") ).chomp();
			var val = line.substring( line.index_of("=") + 1 ).chug();
			string[] key_split = key.split(".");

			// Check for log4vala
			if ( key_split[0] != "log4vala" ) {
				Logger.get_logger("log4vala.internal").warn(
					"Directive does not start with log4vala: %s".printf(line)
				);
				return;
			}

			// Check for type of directive
			if ( key_split.length < 2 ) {
				Logger.get_logger("log4vala.internal").warn(
					"Directive missing type (appender, logger): %s".printf(line)
				);
				return;
			}

			switch( key_split[1] ) {
				case "appender":
					break;
				case "logger":
					var logger_name = line.substring(17);
					if ( logger_name.length > 0 ) {
						loggers.insert( logger_name, new LoggerConfig.from_config(val) );
					} else {
						// figure out root appender
					}
					break;
				default:
					Logger.get_logger("log4vala.internal").warn(
						"Invalid type '%s': %s".printf( key_split[1], line )
					);
					return;
			}
		}

		internal static void reset_config() {
			instance = null;
		}

		internal Config() {
			set_defaults();
		}

		internal void set_defaults() {
			root_appender = new ScreenAppender();
			root_appender.name = "root";
			root_appender.layout = new SimpleLayout();
			root_level = Level.TRACE;
			appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
			loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );
		}

		internal void init( string config_file ) {
			instance = new Config();
			instance.config_file = config_file;
			parse_config();
		}

		internal void init_and_watch( string config_file, int interval ) {
			init(config_file);
			instance.watch_config(interval);
		}

		internal void watch_config( int interval ) {
			File file = File.new_for_path( config_file );
			if ( monitor != null ) {
				monitor.cancel();
			}
			try {
				monitor = file.monitor( FileMonitorFlags.NONE, null );
				monitor.changed.connect( (src, dest, event) => {
					if ( event == FileMonitorEvent.CHANGED || event == FileMonitorEvent.CREATED ) {
						Logger.get_logger("log4vala.internal").info("Reloading log configuration");
						parse_config();
					}
				} );
			} catch ( Error e ) {
				Logger.get_logger("log4vala.internal").error(
					"Unable to monitor config file '%s'.".printf(config_file),
					e
				);
			}
		}
	}
}