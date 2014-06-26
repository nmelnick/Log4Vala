public class Log4ValaTest.Config : AbstractTestCase {
	public Config() {
		base("Config");
		add_test( "singleton", singleton );
		add_test( "get_appenders_for_logger.exact", get_appenders_for_logger_exact );
		add_test( "get_appenders_for_logger.historical", get_appenders_for_logger_historical );
		add_test( "parse_config_line_space", parse_config_line_space );
		add_test( "parse_config_line_comment", parse_config_line_comment );
		add_test( "parse_config_line_init_appender", parse_config_line_init_appender );
		add_test( "parse_config_line_init_logger", parse_config_line_init_logger );
		add_test( "parse_config_line_init_appender_layout", parse_config_line_init_appender_layout );
		add_test( "parse_config_line_init_appender_layout_property", parse_config_line_init_appender_layout_property );
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

	public void parse_config_line_space() {
		var config = Log4Vala.Config.get_config();
		string config_line = "    ";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 0 );
		assert( config.loggers.size() == 0 );
		Log4Vala.Config.reset_config();
	}

	public void parse_config_line_comment() {
		var config = Log4Vala.Config.get_config();
		string config_line = "# A test!";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 0 );
		assert( config.loggers.size() == 0 );
		Log4Vala.Config.reset_config();
	}

	public void parse_config_line_init_appender() {
		var config = Log4Vala.Config.get_config();
		string config_line = "log4vala.appender.foo = Log4Vala.Appender.ScreenAppender";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 1 );
		assert( config.loggers.size() == 0 );
		assert( config.appenders.contains("foo") );
		assert( config.appenders.get("foo").name == "foo" );
		assert( config.appenders.get("foo") is Log4Vala.Appender.ScreenAppender );
		assert( config.appenders.get("foo").layout is Log4Vala.Layout.SimpleLayout );
		Log4Vala.Config.reset_config();
	}

	public void parse_config_line_init_logger() {
		var config = Log4Vala.Config.get_config();
		string config_line = "log4vala.logger.test.class = DEBUG, foo";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 0 );
		assert( config.loggers.size() == 1 );
		assert( config.loggers.contains("test.class") );
		assert( config.loggers.get("test.class").appenders[0] == "foo" );
		assert( config.loggers.get("test.class").level == Log4Vala.Level.DEBUG );
		Log4Vala.Config.reset_config();
	}

	public void parse_config_line_init_appender_layout() {
		var config = Log4Vala.Config.get_config();
		string config_line = "log4vala.appender.foo = Log4Vala.Appender.ScreenAppender";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 1 );
		config_line = "log4vala.appender.foo.layout = Log4Vala.Layout.DescriptiveLayout";
		config.parse_config_line( ref config_line );
		assert( config.appenders.get("foo").layout != null );
		assert( config.appenders.get("foo").layout is Log4Vala.Layout.DescriptiveLayout );
		Log4Vala.Config.reset_config();
	}

	public void parse_config_line_init_appender_layout_property() {
		var config = Log4Vala.Config.get_config();
		string config_line = "log4vala.appender.foo = Log4Vala.Appender.ScreenAppender";
		config.parse_config_line( ref config_line );
		assert( config.appenders.size() == 1 );
		config_line = "log4vala.appender.foo.layout = Log4Vala.Layout.SimpleLayout";
		config.parse_config_line( ref config_line );
		assert( config.appenders.get("foo").layout != null );
		config_line = "log4vala.appender.foo.layout.header = I don't even know";
		config.parse_config_line( ref config_line );
		assert( config.appenders.get("foo").layout.header == "I don't even know" );
		Log4Vala.Config.reset_config();
	}
}
