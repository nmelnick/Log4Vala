/*
 * DescriptiveLayout.vala
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

namespace Log4Vala.Layout {
	/**
	 * DescriptiveLayout provides most of the items needed for a log entry.
	 *
	 * Example:
	 * {{{
	 * 2014-01-01 15:31:48 WARN  (example.class.foo) This is a message!
	 * }}}
	 */
	public class DescriptiveLayout : Object,ILayout {
		public const string error_format = " | Error: Code %d, Domain %" + uint32.FORMAT + ", Message: %s";
		public string header { get; set; }
		public string footer { get; set; }
		public string format( LogEvent event ) {
			var message = event.message;
			if ( event.error != null ) {
				message = message + error_format.printf( event.error.code, event.error.domain, event.error.message );
			}
			return "%s %5s (%s) %s".printf(
				event.timestamp.format("%Y-%m-%d %H:%M:%S"),
				event.log_level.friendly(),
				event.logger_name,
				message
			);
		}
	}
}