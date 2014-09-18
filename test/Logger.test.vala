public class Log4ValaTest.Logger : AbstractTestCase {
	public Logger() {
		base("Logger");
		add_test( "get_logger.instance", get_logger_instance );
		add_test( "get_logger.for_object_instance", get_logger_for_object_instance );
		add_test( "get_logger.for_object_instance.without_translation", get_logger_for_object_instance_without_translation );
		add_test( "get_logger.same.instance", get_logger_same_instance );
		add_test( "log", do_log );
	}

	public void get_logger_instance() {
		var logger = Log4Vala.Logger.get_logger("test.project");
		assert( logger != null );
		assert( logger.name == "test.project" );
		assert( logger.log_level == Log4Vala.Level.TRACE );
		logger.log_level = Log4Vala.Level.INFO;
	}

	public void get_logger_same_instance() {
		var logger = Log4Vala.Logger.get_logger("the.same");
		var logger_two = Log4Vala.Logger.get_logger("the.same");
		assert( logger != null );
		assert( logger_two != null );
		assert( logger == logger_two );
	}

	public void get_logger_for_object_instance() {
		var logger = Log4Vala.Logger.get_logger_for_object( new TestAppender() );
		assert( logger != null );
		assert( logger.name == "Test.Appender" );

		logger = Log4Vala.Logger.get_logger_for_object(this);
		assert( logger != null );
		assert( logger.name == "Log4.Vala.Test.Logger" );
	}

	public void get_logger_for_object_instance_without_translation() {
		Log4Vala.Config.get_config().translate_type_name = false;
		var logger = Log4Vala.Logger.get_logger_for_object( new TestAppender() );
		assert( logger != null );
		assert( logger.name == "TestAppender" );

		logger = Log4Vala.Logger.get_logger_for_object(this);
		assert( logger != null );
		assert( logger.name == "Log4ValaTestLogger" );
		Log4Vala.Config.get_config().translate_type_name = true;
	}

	public void do_log() {
		var appender = new TestAppender();
		Log4Vala.Config.get_config().appenders.insert( "test.appender", appender );
		Log4Vala.Config.get_config().loggers.insert( "test.class", new Log4Vala.LoggerConfig( {"test.appender"}, Log4Vala.Level.WARN ) );
		var logger = Log4Vala.Logger.get_logger("test.class");
		logger.trace("trace");
		assert( appender.last_entry == null );
		logger.debug("debug");
		assert( appender.last_entry == null );
		logger.info("info");
		assert( appender.last_entry == null );
		logger.warn("warn");
		assert( "WARN" in appender.last_entry );
		assert( "warn" in appender.last_entry );
		logger.error("error");
		assert( "ERROR" in appender.last_entry );
		assert( "error" in appender.last_entry );
		logger.fatal("fatal");
		assert( "FATAL" in appender.last_entry );
		assert( "fatal" in appender.last_entry );
	}
}

public class TestAppender : Object,Log4Vala.Appender.IAppender {
	public string name { get; set; default = "TestAppender"; }
	public Log4Vala.Layout.ILayout? layout { get; set; default = new Log4Vala.Layout.SimpleLayout(); }
	public string last_entry { get; set; }

	public void append( Log4Vala.LogEvent event ) {
		last_entry = name + " | " + this.layout.format(event);
	}
}
