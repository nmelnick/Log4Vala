public class Log4ValaTest.Logger : AbstractTestCase {
	public Logger() {
		base("Logger");
		add_test( "get_logger.instance", get_logger_instance );
		add_test( "get_logger.same.instance", get_logger_same_instance );
	}

	public void get_logger_instance() {
		var logger = Log4Vala.Logger.get_logger("test.project");
		assert( logger != null );
		assert( logger.name == "test.project" );
		assert( logger.log_level == Log4Vala.Level.TRACE );
		logger.log_level = Log4Vala.Level.INFO;
		logger.trace("trace");
		logger.debug("debug");
		logger.info("info");
		logger.warn("warn");
		logger.error("error");
		logger.fatal("fatal");
	}

	public void get_logger_same_instance() {
		var logger = Log4Vala.Logger.get_logger("the.same");
		var logger_two = Log4Vala.Logger.get_logger("the.same");
		assert( logger != null );
		assert( logger_two != null );
		assert( logger == logger_two );
	}
}
