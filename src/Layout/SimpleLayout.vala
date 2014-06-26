namespace Log4Vala.Layout {
	/**
	 * SimpleLayout provides a very simple layout consisting of the log level,
	 * a dash, and then the message.
	 *
	 * Example:
	 * {{{
	 * WARN - This is a message!
	 * }}}
	 */
	public class SimpleLayout : Object,ILayout {
		public string header { get; set; }
		public string footer { get; set; }
		public string format( LogEvent event ) {
			return "%s - %s".printf(
				event.log_level.friendly(),
				event.message
			);
		}
	}
}