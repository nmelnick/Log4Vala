public class Log4ValaTest.LoggerConfig : AbstractTestCase {
	public LoggerConfig() {
		base("LoggerConfig");
		add_test( "from_config_level_only", from_config_level_only );
		add_test( "from_config_appender_only", from_config_appender_only );
		add_test( "from_config_level_append", from_config_level_append );
	}

	public void from_config_level_only() {
		var config = new Log4Vala.LoggerConfig.from_config("DEBUG");
		assert( config != null );
		assert( config.level == Log4Vala.Level.DEBUG );
		assert( config.appenders == null );
	}

	public void from_config_appender_only() {
		var config = new Log4Vala.LoggerConfig.from_config("Appender1");
		assert( config != null );
		assert( config.level == null );
		assert( config.appenders[0] == "Appender1" );
	}

	public void from_config_level_append() {
		var config = new Log4Vala.LoggerConfig.from_config("DEBUG, Appender1, Appender2");
		assert( config != null );
		assert( config.level == Log4Vala.Level.DEBUG );
		assert( config.appenders[0] == "Appender1" );
		assert( config.appenders[1] == "Appender2" );
	}
}
