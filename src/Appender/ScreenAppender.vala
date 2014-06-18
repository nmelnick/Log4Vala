using Log4Vala.Layout;
namespace Log4Vala.Appender {
	public class ScreenAppender : Object,IAppender {
		public string name { get; set; }
		public ILayout layout { get; set; }
		public void append( LogEvent event ) {
			stdout.printf( "%s\n", this.layout.format(event) );
		}
	}
}