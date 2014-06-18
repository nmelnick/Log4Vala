using Log4Vala.Appender;
using Log4Vala.Layout;
namespace Log4Vala {
	public class Config : Object {
		private static Config? instance;

		public HashTable<string,IAppender?> appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
		public HashTable<string,ILayout?> layouts = new HashTable<string,ILayout?>( str_hash, str_equal );
		public HashTable<string,LoggerConfig?> loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );

		public static Config get_config() {
			if ( Config.instance == null ) {
				Config.instance = new Config();
			}
			return Config.instance;
		}

		internal static void reset_config() {
			instance = null;
		}

		internal Config() {}

		public IAppender? get_appender_for_logger( string name ) {
			if ( appenders.contains(name) ) {
				return appenders.get(name);
			}
			string temp_name = null;
			do {
				temp_name = name.substring( 0, name.last_index_of(".") );
				stdout.printf( "\n%s -> %s", name, temp_name );
				name = temp_name;
			} while ( name != temp_name );
			return null;
		}
	}
}