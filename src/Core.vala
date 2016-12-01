/*
 * Core.vala
 *
 * The Log4Vala Project
 *
 * Copyright 2013-2016 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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