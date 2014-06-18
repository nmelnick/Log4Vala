using Log4Vala.Layout;
namespace Log4Vala {
	public class LogEvent : Object {
		/**
		 * Name of the logger that fired the event.
		 */
		public string logger_name { get; set; }
		/**
		 * Log level of event.
		 */
		public Level log_level { get; set; }
		/**
		 * DateTime when the event was fired.
		 */
		public DateTime timestamp { get; set; }
		/**
		 * If in a thread, thread ID where the event was fired. Since Vala/GLib
		 * does not expose thread IDs or names, this is the 64-bit memory
		 * address of the thread, so can only be used to determine events fired
		 * from the same thread.
		 */
		public int64 thread_id { get; set; }
		/**
		 * If available from the OS, process ID where the event was fired.
		 */
		public int process_id { get; set; }
		/**
		 * Message logged.
		 */
		public string? message { get; set; }
		/**
		 * Error logged, if provided.
		 */
		public Error? error { get; set; }

		public LogEvent() {}

		/**
		 * Create a new log event with all appropriate data.
		 * @param logger_name Name of logger firing event
		 * @param log_level Level enum of log level
		 * @param message Message to be logged
		 * @param error Error to be logged, if available
		 * @param timestamp DateTime of the current event, defaults to now.
		 */
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
	}
}