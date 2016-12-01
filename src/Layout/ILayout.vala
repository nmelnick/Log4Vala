/*
 * ILayout.vala
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
	 * Define a layout for Log4Vala.
	 *
	 * To implement a layout for Log4Vala, a class needs to apply ILayout, and
	 * define two properties and one method.
	 */
	public interface ILayout : Object {
		/**
		 * An optional string that is sent at the beginning of an appender, for
		 * instance, the beginning of a new file.
		 */
		public abstract string header { get; set; }

		/**
		 * An optional string that is sent at the end of an appender, for
		 * instance, the end of a file before opening a new one or on exit.
		 */
		public abstract string footer { get; set; }

		/**
		 * Provides a LogEvent that one can format for output. Returns a string
		 * to be sent to one or more appenders.
		 * @param event a LogEvent instance
		 */
		public abstract string format( LogEvent event );
	}
}