using Log4Vala.Layout;
namespace Log4Vala {
	public class LogEvent : Object {
		public string logger_name { get; set; }
		public Level log_level { get; set; }
		public DateTime timestamp { get; set; }
		public int64 thread_id { get; set; }
		public int process_id { get; set; }
		public string? message { get; set; }
		public Error? error { get; set; }

		public ILayout layout { get; set; }

		public LogEvent() {}

		public LogEvent.with_message( string logger_name,
			                          Level log_level,
			                          string? message = null,
			                          Error? error = null,
			                          DateTime timestamp = new DateTime.now_utc() ) {
			this.logger_name = logger_name;
			this.log_level = log_level;
			this.message = message;
			this.error = error;
			this.timestamp = timestamp;
			this.process_id = (int) Posix.getpid();
			if ( Thread.supported() ) {
				this.thread_id = (int64) Thread.self<int>();
			}
		}

		public string render() {
			return this.layout.format(this);
		}
	}
}