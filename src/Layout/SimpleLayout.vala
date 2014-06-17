namespace Log4Vala.Layout {
	public class SimpleLayout : Object,ILayout {
		public string header { get; set; }
		public string footer { get; set; }
		public string format( LogEvent event ) {
			return "%s %5s %s %s".printf(
				event.timestamp.format("%Y-%m-%d %H:%M:%S"),
				event.log_level.friendly(),
				event.logger_name,
				event.message
			);
		}
	}
}