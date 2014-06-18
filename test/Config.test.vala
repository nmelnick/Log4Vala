public class Log4ValaTest.Config : AbstractTestCase {
	public Config() {
		base("Config");
		add_test( "singleton", singleton );
		add_test( "get_appenders_for_logger.exact", get_appenders_for_logger_exact );
		add_test( "get_appenders_for_logger.historical", get_appenders_for_logger_historical );
	}

	public void singleton() {
		var config = Log4Vala.Config.get_config();
		assert( config != null );
		assert( config == Log4Vala.Config.get_config() );
	}

	public void get_appenders_for_logger_exact() {
		var config = Log4Vala.Config.get_config();
		var appender = new Log4Vala.Appender.ScreenAppender();
		config.appenders.insert( "screen", appender );
		config.loggers.insert( "test.logger", new Log4Vala.LoggerConfig( {"screen"}, Log4Vala.Level.WARN ) );
		assert( config.get_appenders_for_logger("test.logger")[0] == appender );
		Log4Vala.Config.reset_config();
	}

	public void get_appenders_for_logger_historical() {
		var config = Log4Vala.Config.get_config();
		var appender = new Log4Vala.Appender.ScreenAppender();
		appender.name = "asdf";
		config.appenders.insert( "screen", appender );
		config.loggers.insert( "test.logger", new Log4Vala.LoggerConfig( {"screen"}, Log4Vala.Level.WARN ) );
		var new_appender = config.get_appenders_for_logger("test.logger.foo")[0];
		assert( new_appender == appender );
		Log4Vala.Config.reset_config();
	}
}
