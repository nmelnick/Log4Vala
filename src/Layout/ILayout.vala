namespace Log4Vala.Layout {
	public interface ILayout : Object {
		public abstract string header { get; set; }
		public abstract string footer { get; set; }
		public abstract string format( LogEvent event );
	}
}