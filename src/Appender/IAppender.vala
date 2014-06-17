namespace Log4Vala.Appender {
	public interface IAppender : Object {
		public abstract void append( LogEvent event );
	}
}