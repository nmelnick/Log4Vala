public class Log4ValaTest.Level : AbstractTestCase {
	public Level() {
		base("Level");
		add_test( "check_trace", check_trace );
		add_test( "check_debug", check_debug );
		add_test( "check_info", check_info );
		add_test( "check_warn", check_warn );
		add_test( "check_error", check_error );
		add_test( "check_fatal", check_fatal );
	}

	public void check_trace() {
		assert( Log4Vala.Level.TRACE > -1 );
	}

	public void check_debug() {
		assert( Log4Vala.Level.DEBUG > -1 );
	}

	public void check_info() {
		assert( Log4Vala.Level.INFO > -1 );
	}

	public void check_warn() {
		assert( Log4Vala.Level.WARN > -1 );
	}

	public void check_error() {
		assert( Log4Vala.Level.ERROR > -1 );
	}

	public void check_fatal() {
		assert( Log4Vala.Level.FATAL > -1 );
	}
}