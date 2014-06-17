namespace Log4Vala.Appender {
	public class ScreenAppender : Object,IAppender {
		public void append( LogEvent event ) {
			stdout.printf( "%s\n", event.render() );
		}
	}
}