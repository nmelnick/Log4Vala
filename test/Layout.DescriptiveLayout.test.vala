public class Log4ValaTest.Layout.DescriptiveLayout : AbstractTestCase {
	public DescriptiveLayout() {
		base("Layout.DescriptiveLayout");
		add_test( "format", format );
		add_test( "format.with.null", format_with_null );
	}

	public void format() {
		var layout = new Log4Vala.Layout.DescriptiveLayout();
		assert( layout != null );
		assert( layout.header == null );
		assert( layout.footer == null );
		var event = new Log4Vala.LogEvent.with_message(
			"some.test",
			Log4Vala.Level.TRACE,
			"a test message"
		);
		assert( layout.format(event).substring(20) == "TRACE some.test a test message" );
	}

	public void format_with_null() {
		var layout = new Log4Vala.Layout.DescriptiveLayout();
		assert( layout != null );
		assert( layout.header == null );
		assert( layout.footer == null );
		var event = new Log4Vala.LogEvent.with_message(
			"some.test",
			Log4Vala.Level.TRACE,
			null
		);
		assert( layout.format(event).substring(20) == "TRACE some.test (null)" );
	}
}
