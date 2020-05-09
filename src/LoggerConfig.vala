/*
 * LoggerConfig.vala
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
	public class LoggerConfig {
		private const string[] levels = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL" };
		public string[] appenders;
		public Level? level;

		public LoggerConfig( string[] appenders, Level? level ) {
			this.appenders = appenders;
			this.level = level;
		}

		public LoggerConfig.from_config( string config_value ) {
			string[] appenders = new string[0];
			var elements = config_value.replace( " ", "" ).split(",");

			foreach ( var element in elements ) {
				bool is_element = false;
				foreach ( var level in levels ) {
					if ( element == level ) {
						this.level = Level.get_by_name(level);
						is_element = true;
						break;
					}
				}
				if (is_element) {
					continue;
				}
				appenders += element;
			}
			if ( appenders.length > 0 ) {
				this.appenders = appenders;
			}
		}
	}
}
