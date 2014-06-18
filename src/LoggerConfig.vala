namespace Log4Vala {
	public class LoggerConfig {
		public string appender;
		public string layout;

		public LoggerConfig( string appender, string layout ) {
			this.appender = appender;
			this.layout = layout;
		}
	}
}