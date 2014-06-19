namespace Log4Vala {
	/**
	 * Initialize Log4Vala for the application.
	 * @param config_file Path to configuration file.
	 */
	public static void init( string? config_file = null ) {
		Config.init(config_file);
	}

	/**
	 * Initialize Log4Vala for the application, and watch the config file for
	 * changes
	 * @param config_file Path to configuration file.
	 * @param interval Interval, in seconds, to poll the file. Default 30.
	 */
	public static void init_and_watch( string? config_file = null, int interval = 30 ) {
		Config.init_and_watch( config_file, interval );
	}
}