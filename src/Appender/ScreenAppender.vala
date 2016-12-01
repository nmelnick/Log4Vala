/*
 * ScreenAppender.vala
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

using Log4Vala.Layout;
namespace Log4Vala.Appender {
	/**
	 * Append log data to the screen, defaulting to STDOUT. Setting "stderr" to
	 * "1" will output to STDERR.
	 */
	public class ScreenAppender : Object,IAppender {
		public string name { get; set; }
		public ILayout? layout { get; set; }

		/**
		 * Set stderr to "1" to output to STDERR.
		 */
		public string stderr { get; set; default = "0"; }

		public void append( LogEvent event ) {
			if ( this.stderr != "0" ) {
				stderr.printf( "%s\n", this.layout.format(event) );
			} else {
				stdout.printf( "%s\n", this.layout.format(event) );
			}
		}
	}
}