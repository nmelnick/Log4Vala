using Log4Vala.Layout;
namespace Log4Vala.Appender {
	/**
	 * Append log data to the screen, defaulting to STDOUT. Setting "stderr" to
	 * "1" will output to STDERR.
	 */
	public class ScreenAppender : Object,IAppender {
		public string name { get; set; }
		public ILayout? layout { get; set; }

		/**
		 * Set stderr to "1" to output to STDERR.
		 */
		public string stderr { get; set; default = "0"; }

		public void append( LogEvent event ) {
			if ( this.stderr != "0" ) {
				stderr.printf( "%s\n", this.layout.format(event) );
			} else {
				stdout.printf( "%s\n", this.layout.format(event) );
			}
		}
	}
}