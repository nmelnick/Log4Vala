namespace Log4Vala {
	public class LoggerConfig {
		private static const string[] levels = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL" };
		public string[] appenders;
		public Level? level;

		public LoggerConfig( string[] appenders, Level? level ) {
			this.appenders = appenders;
			this.level = level;
		}

		public LoggerConfig.from_config( string config_value ) {
			string[] appenders = new string[0];
			var elements = config_value.replace( " ", "" ).split(",");

			foreach ( var element in elements ) {
				bool is_element = false;
				foreach ( var level in levels ) {
					if ( element == level ) {
						this.level = Level.get_by_name(level);
						is_element = true;
						break;
					}
				}
				if (is_element) {
					continue;
				}
				appenders += element;
			}
			if ( appenders.length > 0 ) {
				this.appenders = appenders;
			}
		}
	}
}
