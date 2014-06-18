namespace Log4Vala {
	public class LoggerConfig {
		public string[] appenders;
		public Level? level;

		public LoggerConfig( string[] appenders, Level? level ) {
			this.appenders = appenders;
			this.level = level;
		}
	}
}