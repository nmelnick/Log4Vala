namespace Log4Vala.Layout {
	/**
	 * DescriptiveLayout provides most of the items needed for a log entry.
	 *
	 * Example:
	 * {{{
	 * 2014-01-01 15:31:48 WARN  (example.class.foo) This is a message!
	 * }}}
	 */
	public class DescriptiveLayout : Object,ILayout {
		public static const string error_format = " | Error: Code %d, Domain %" + uint32.FORMAT + ", Message: %s";
		public string header { get; set; }
		public string footer { get; set; }
		public string format( LogEvent event ) {
			var message = event.message;
			if ( event.error != null ) {
				message = message + error_format.printf( event.error.code, event.error.domain, event.error.message );
			}
			return "%s %5s (%s) %s".printf(
				event.timestamp.format("%Y-%m-%d %H:%M:%S"),
				event.log_level.friendly(),
				event.logger_name,
				message
			);
		}
	}
}