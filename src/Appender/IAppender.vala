using Log4Vala.Layout;
namespace Log4Vala.Appender {
	public interface IAppender : Object {
		public abstract string name { get; set; }
		public abstract ILayout? layout { get; set; }
		public abstract void append( LogEvent event );
	}
}