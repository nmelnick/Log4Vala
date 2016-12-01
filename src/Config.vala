/*
 * Config.vala
 *
 * The Log4Vala Project
 *
 * Copyright 2013-2016 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
		private string root_appender_description;

		internal HashTable<string,IAppender?> appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
		internal HashTable<string,LoggerConfig?> loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );

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
		 * Translate Type name to a guessed class name when getting a logger by
		 * object.
		 */
		public bool translate_type_name { get; set; default = true; }

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
		 * Add an appender manually, with the referenced appender name and an
		 * instance of a new, pre-configured appender.
		 * @param appender_name Unique name to refer to this appender
		 * @param appender Instance of an appender
		 */
		public void add_appender( string appender_name, IAppender appender ) {
			appenders.insert( appender_name, appender );
		}

		/**
		 * Remove an appender manually. If the appender does not already exist,
		 * nothing happens.
		 * @param appender_name Unique appender to remove
		 */
		public void remove_appender( string appender_name ) {
			if ( appenders.contains(appender_name) ) {
				appenders.remove(appender_name);
			}
		}

		/**
		 * Add a logger manually, with the name of a logger, and the configured
		 * appender(s) and log level as a LoggerConfig object.
		 * @param logger_name Unique name for a logger
		 * @param config LoggerConfig instance
		 */
		public void add_logger( string logger_name, LoggerConfig config ) {
			loggers.insert( logger_name, config );
		}

		/**
		 * Remove a logger manually. If the logger does not already exist,
		 * nothing happens.
		 * @param logger_name Unique appender to remove
		 */
		public void remove_logger( string logger_name ) {
			if ( loggers.contains(logger_name) ) {
				loggers.remove(logger_name);
			}
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

			if ( root_appender_description != null ) {
				var config = new LoggerConfig.from_config(root_appender_description);
				if ( config.appenders != null && config.appenders[0] != null ) {
					root_appender = appenders.get( config.appenders[0] );
				}
				if ( config.level != null ) {
					root_level = config.level;
				}
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
					var appender_name = key_split[2];
					if ( key_split.length > 3 && ! appenders.contains(appender_name) ) {
						Logger.get_logger("log4vala.internal").error(
							"Appender '%s' is being configured, but we do not know what it is yet: %s".printf( appender_name, line )
						);
						return;
					}
					if ( key_split.length == 3 ) {
						// New appender
						var type = Type.from_name( val.replace( ".", "" ) );
						if ( type == 0 ) {
							Logger.get_logger("log4vala.internal").error(
								"Appender '%s' created with invalid Appender type '%s'".printf( appender_name, val )
							);
							return;
						}
						IAppender appender = (IAppender) Object.new(type);
						appender.name = appender_name;
						// Default layout is Simple
						appender.layout = new SimpleLayout();
						add_appender( appender_name, appender );
					} else if ( key_split[3] == "layout" ) {
						var appender = appenders.get(appender_name);
						if ( key_split.length > 4 && appender.layout == null ) {
							Logger.get_logger("log4vala.internal").error(
								"Appender '%s' layout is being configured, but we do not know what it is yet: %s".printf( appender_name, line )
							);
							return;
						}
						if ( key_split.length == 4 ) {
							// New layout
							var type = Type.from_name( val.replace( ".", "" ) );
							if ( type == 0 ) {
								Logger.get_logger("log4vala.internal").error(
									"Appender '%s' layout created with invalid type '%s'".printf( appender_name, val )
								);
								return;
							}
							ILayout layout = (ILayout) Object.new(type);
							appender.layout = layout;
						} else {
							var layout = appender.layout;
							var property = key_split[4].replace( "_", "-" );
							layout.set_property( property, val );
						}

					} else {
						var appender = appenders.get(appender_name);
						var property = key_split[3].replace( "_", "-" );
						if ( property == "name" || property == "append" ) {
							return;
						}
						appender.set_property( property, val );
					}
					break;
				case "logger":
					if ( key.length > 16 ) {
						var logger_name = key.substring(16);
						add_logger( logger_name, new LoggerConfig.from_config(val) );
					} else {
						root_appender_description = val;
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
			Type f = typeof(ScreenAppender);
			f = typeof(FileAppender);
			f = typeof(SocketAppender);
			f = typeof(DescriptiveLayout);
			f = typeof(PatternLayout);
			f = typeof(SimpleLayout);
		}

		internal void set_defaults() {
			root_appender = new ScreenAppender();
			root_appender.name = "root";
			root_appender.layout = new SimpleLayout();
			root_level = Level.TRACE;
			appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
			loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );
		}

		internal static void init( string? config_file ) {
			instance = new Config();
			instance.config_file = config_file;
			if ( instance.config_file != null ) {
				instance.parse_config();
			}
		}

		internal static void init_and_watch( string? config_file, int interval ) {
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
