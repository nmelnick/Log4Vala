using Log4Vala.Appender;
using Log4Vala.Layout;
namespace Log4Vala {
	public class Config : Object {
		private static Config instance;

		public HashTable<string,IAppender?> appenders = new HashTable<string,IAppender?>( str_hash, str_equal );
		public HashTable<string,ILayout?> layouts = new HashTable<string,ILayout?>( str_hash, str_equal );
		public HashTable<string,LoggerConfig?> loggers = new HashTable<string,LoggerConfig?>( str_hash, str_equal );

		public static Config get_config() {
			if ( Config.instance == null ) {
				Config.instance = new Config();
			}
			return Config.instance;
		}

		internal Config() {

		}
	}
}