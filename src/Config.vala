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
		public HashTable<string,ILayout?> layouts = new HashTable<string,ILayout?>( str_hash, str_equal );
		public HashTable<string,LoggerConfig?> loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );

		/**
		 * Default logging appender.
		 */
		public IAppender root_appender { get; set; }
		/**
		 * Default logging layout.
		 */
		public ILayout root_layout { get; set; }

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
		public IAppender? get_appender_for_logger( string name ) {
			if ( appenders.contains(name) ) {
				return appenders.get(name);
			}
			string temp_name = null;
			do {
				temp_name = name.substring( 0, name.last_index_of(".") );
				name = temp_name;
				if ( appenders.contains(name) ) {
					return appenders.get(name);
				}
			} while ( name != temp_name );
			return root_appender;
		}

		/**
		 * Retrieve appropriate layout for the given logger name.
		 */
		public ILayout? get_layout_for_logger( string name ) {
			if ( layouts.contains(name) ) {
				return layouts.get(name);
			}
			string temp_name = null;
			do {
				temp_name = name.substring( 0, name.last_index_of(".") );
				name = temp_name;
				if ( layouts.contains(name) ) {
					return layouts.get(name);
				}
			} while ( name != temp_name );
			return root_layout;
		}

		internal static void reset_config() {
			instance = null;
		}

		internal Config() {
			root_appender = new ScreenAppender();
			root_layout = new SimpleLayout();
		}
	}
}