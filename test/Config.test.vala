public class Log4ValaTest.Config : AbstractTestCase {
	public Config() {
		base("Config");
		add_test( "get_appender_for_logger.exact", get_appender_for_logger_exact );
		add_test( "get_appender_for_logger.historical", get_appender_for_logger_historical );
	}

	public void get_appender_for_logger_exact() {
		var config = Log4Vala.Config.get_config();
		var appender = new Log4Vala.Appender.ScreenAppender() ;
		config.appenders.insert( "test.logger", appender );
		assert( config.get_appender_for_logger("test.logger") == appender );
		Log4Vala.Config.reset_config();
	}

	public void get_appender_for_logger_historical() {
		var config = Log4Vala.Config.get_config();
		var appender = new Log4Vala.Appender.ScreenAppender() ;
		config.appenders.insert( "test.logger", appender );
		assert( config.get_appender_for_logger("test.logger.foo") == appender );
		Log4Vala.Config.reset_config();
	}
}