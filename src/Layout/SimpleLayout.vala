/*
 * SimpleLayout.vala
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
	 * SimpleLayout provides a very simple layout consisting of the log level,
	 * a dash, and then the message.
	 *
	 * Example:
	 * {{{
	 * WARN - This is a message!
	 * }}}
	 */
	public class SimpleLayout : Object,ILayout {
		public string header { get; set; }
		public string footer { get; set; }
		public string format( LogEvent event ) {
			return "%s - %s".printf(
				event.log_level.friendly(),
				event.message
			);
		}
	}
}